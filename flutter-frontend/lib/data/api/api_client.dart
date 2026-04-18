import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/api_constants.dart';

/// Singleton Dio HTTP client with Firebase auth interceptor.
/// Automatically attaches `Bearer <idToken>` to every request.
class ApiClient {
  static ApiClient? _instance;
  late final Dio dio;

  ApiClient._() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.defaultBaseUrl,
      connectTimeout: ApiConstants.requestTimeout,
      receiveTimeout: ApiConstants.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Auth interceptor — attaches Firebase ID token to every request
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          try {
            final token = await user.getIdToken();
            options.headers['Authorization'] = 'Bearer $token';
          } catch (_) {
            // Token refresh failed — proceed without auth
          }
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Log API errors for debugging
        // ignore: avoid_print
        print('[API Error] ${error.requestOptions.path}: ${error.message}');
        handler.next(error);
      },
    ));
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  /// Update the base URL (e.g., from settings or build config).
  void setBaseUrl(String url) {
    dio.options.baseUrl = url;
  }
}
