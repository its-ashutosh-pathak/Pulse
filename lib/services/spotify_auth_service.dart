import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:pkce/pkce.dart';

class SpotifyAuthService {
  static const _storage = FlutterSecureStorage();
  static final _dio = Dio(BaseOptions(
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Pulse/1.0.0',
    },
  ));
  
  static const String _redirectUri = 'pulse://spotify-callback';

  static Future<void> authenticate(String clientId) async {
    final pkcePair = PkcePair.generate(length: 64);

    final url = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': _redirectUri,
      'scope': 'playlist-read-private playlist-read-collaborative user-library-read user-read-private user-read-email',
      'code_challenge_method': 'S256',
      'code_challenge': pkcePair.codeChallenge,
      'show_dialog': 'true',
    });

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: 'pulse',
      );

      final returnedCode = Uri.parse(result).queryParameters['code'];
      if (returnedCode == null) throw Exception('No code returned from Spotify');

      await _exchangeCodeForToken(clientId, returnedCode, pkcePair.codeVerifier);
    } catch (e) {
      debugPrint('[SpotifyAuth] Auth error: $e');
      rethrow;
    }
  }

  static Future<void> _exchangeCodeForToken(String clientId, String code, String codeVerifier) async {
    final response = await _dio.post(
      'https://accounts.spotify.com/api/token',
      data: 'client_id=${Uri.encodeComponent(clientId)}&grant_type=authorization_code&code=${Uri.encodeComponent(code)}&redirect_uri=${Uri.encodeComponent(_redirectUri)}&code_verifier=${Uri.encodeComponent(codeVerifier)}',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );

    await _saveTokens(clientId, response.data);
  }

  static Future<String?> getValidAccessToken(String clientId) async {
    final expiresAtStr = await _storage.read(key: 'spotify_expires_at_$clientId');
    if (expiresAtStr == null) return null;

    final expiresAt = DateTime.parse(expiresAtStr);
    if (DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)))) {
      // Token expired or about to expire, refresh it
      try {
        await _refreshToken(clientId);
      } catch (e) {
        debugPrint('[SpotifyAuth] Failed to refresh token: $e');
        return null;
      }
    }

    return await _storage.read(key: 'spotify_access_token_$clientId');
  }

  static Future<void> _refreshToken(String clientId) async {
    final refreshToken = await _storage.read(key: 'spotify_refresh_token_$clientId');
    if (refreshToken == null) throw Exception('No refresh token available');

    final response = await _dio.post(
      'https://accounts.spotify.com/api/token',
      data: 'client_id=${Uri.encodeComponent(clientId)}&grant_type=refresh_token&refresh_token=${Uri.encodeComponent(refreshToken)}',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );

    await _saveTokens(clientId, response.data, oldRefreshToken: refreshToken);
  }

  static Future<void> _saveTokens(String clientId, Map<String, dynamic> data, {String? oldRefreshToken}) async {
    final accessToken = data['access_token'] as String;
    final expiresIn = data['expires_in'] as int;
    final refreshToken = data['refresh_token'] as String? ?? oldRefreshToken;

    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    await _storage.write(key: 'spotify_access_token_$clientId', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'spotify_refresh_token_$clientId', value: refreshToken);
    }
    await _storage.write(key: 'spotify_expires_at_$clientId', value: expiresAt.toIso8601String());
  }

  static Future<void> logout(String clientId) async {
    await _storage.delete(key: 'spotify_access_token_$clientId');
    await _storage.delete(key: 'spotify_refresh_token_$clientId');
    await _storage.delete(key: 'spotify_expires_at_$clientId');
  }
}
