import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_provider.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

// ── Auth State ──────────────────────────────────────────────────────────────
final unreadBadgeTimeProvider = StateProvider<int>((ref) => 0);

class AuthState {
  final User? user;
  final String? displayName;
  final String? photoURL;
  final bool loading;

  const AuthState({
    this.user,
    this.displayName,
    this.photoURL,
    this.loading = true,
  });

  AuthState copyWith({
    User? user,
    String? displayName,
    String? photoURL,
    bool? loading,
  }) {
    return AuthState(
      user: user ?? this.user,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      loading: loading ?? this.loading,
    );
  }

  bool get isLoggedIn => user != null;
  bool get isAdmin => isLoggedIn && user?.email == kAdminEmail;
  String get initials {
    final name = displayName ?? user?.displayName ?? 'P';
    return name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();
  }
}

// ── Auth Provider ───────────────────────────────────────────────────────────

/// Port of AuthContext.jsx — handles Firebase auth + Firestore profile sync.
class AuthNotifier extends Notifier<AuthState> {
  StreamSubscription<User?>? _authSub;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  AuthState build() {
    // Listen to auth state changes (matches onAuthStateChanged in React)
    _authSub?.cancel();
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);

    // Cancel subscription when provider is disposed
    ref.onDispose(() => _authSub?.cancel());

    return const AuthState(loading: true);
  }

  Future<void> _onAuthChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      state = const AuthState(user: null, loading: false);
      return;
    }

    String? displayName = firebaseUser.displayName;
    String? photoURL = firebaseUser.photoURL;

    // 1. INSTANT LOCAL CACHE LOAD
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedName = prefs.getString('cached_displayName_${firebaseUser.uid}');
      final cachedPhoto = prefs.getString('cached_photoURL_${firebaseUser.uid}');
      final cachedColor = prefs.getInt('cached_accentColor_${firebaseUser.uid}');

      if (cachedName != null) displayName = cachedName;
      if (cachedPhoto != null) photoURL = cachedPhoto;
      if (cachedColor != null) {
        ref.read(settingsProvider.notifier).setAccentColor(Color(cachedColor), syncToFirestore: false);
      }
    } catch (e) {
      debugPrint('[Auth] Cache read error: $e');
    }

    // Instantly update state so UI renders immediately
    state = AuthState(
      user: firebaseUser,
      displayName: displayName ?? 'Pulse User',
      photoURL: (photoURL == null || photoURL.isEmpty) ? 'assets/avatars/4.jpeg' : photoURL,
      loading: false,
    );

    // 2. BACKGROUND FIRESTORE SYNC
    // Fire and forget (don't block the UI)
    _syncFirestoreProfile(firebaseUser, displayName, photoURL);
  }

  Future<void> _syncFirestoreProfile(User firebaseUser, String? currentName, String? currentPhoto) async {
    String? displayName = currentName;
    String? photoURL = currentPhoto;

    try {
      final docRef = _db.collection('users').doc(firebaseUser.uid);
      final snap = await docRef.get(const GetOptions(source: Source.serverAndCache));

      if (!snap.exists) {
        await docRef.set({
          'uid': firebaseUser.uid,
          'displayName': firebaseUser.displayName ?? 'Pulse User',
          'email': firebaseUser.email,
          'photoURL': firebaseUser.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        final data = snap.data()!;
        
        // Repair missing fields for affected users & fix race condition
        bool needsRepair = false;
        final repairUpdates = <String, dynamic>{};

        if (data['email'] == null && firebaseUser.email != null) {
          repairUpdates['email'] = firebaseUser.email;
          needsRepair = true;
        }
        if (data['uid'] == null) {
          repairUpdates['uid'] = firebaseUser.uid;
          needsRepair = true;
        }
        if (data['createdAt'] == null) {
          repairUpdates['createdAt'] = FieldValue.serverTimestamp();
          needsRepair = true;
        }
        if (data['photoURL'] == null && firebaseUser.photoURL != null) {
          repairUpdates['photoURL'] = firebaseUser.photoURL;
          needsRepair = true;
        }

        // Cleanup old settings fields from the root document
        // Includes old field names from previous app versions
        final ghostFields = [
          // Current name variants
          'accentColorInt',
          'crossfadeDuration',
          'equalizerEnabled',
          'equalizerPreset',
          'equalizerGains',
          'dataSaverMode',
          'streamingQuality',
          'downloadQuality',
          // Old field names from previous versions
          'eqEnabled',
          'eqPreset',
          'eqCustomGains',
          'eqGains',
          'crossfade',
          'crossfadeSeconds',
          'accentColor',
          'dataSaver',
        ];
        
        for (final field in ghostFields) {
          if (data.containsKey(field)) {
            repairUpdates[field] = FieldValue.delete();
            needsRepair = true;
          }
        }

        if (needsRepair) {
          await docRef.update(repairUpdates);
        }

        // Prefer Firestore profile data over Firebase Auth data
        if (data['displayName'] != null) displayName = data['displayName'];
        if (data['photoURL'] != null) photoURL = data['photoURL'];
        
        final prefs = await SharedPreferences.getInstance();
        if (displayName != null) prefs.setString('cached_displayName_${firebaseUser.uid}', displayName);
        if (photoURL != null) prefs.setString('cached_photoURL_${firebaseUser.uid}', photoURL);
      }

      // Fetch user settings from subcollection
      try {
        DocumentSnapshot<Map<String, dynamic>> settingsSnap = await _db
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('settings')
            .doc('preferences')
            .get(const GetOptions(source: Source.server));

        // Migration fallback 1: the recent typo 'preference'
        if (!settingsSnap.exists) {
          settingsSnap = await _db
              .collection('users')
              .doc(firebaseUser.uid)
              .collection('settings')
              .doc('preference')
              .get(const GetOptions(source: Source.server));
        }

        // Migration fallback 2: the very old 'settings_preference/app_settings'
        if (!settingsSnap.exists) {
          settingsSnap = await _db
              .collection('users')
              .doc(firebaseUser.uid)
              .collection('settings_preference')
              .doc('app_settings')
              .get(const GetOptions(source: Source.server));
        }

        if (settingsSnap.exists && settingsSnap.data() != null) {
          // updateFromBackend sets _firestoreLoaded=true and persists everything
          ref.read(settingsProvider.notifier).updateFromBackend(settingsSnap.data()!);

          // One-time migration: clean up the legacy string-format accentColor field
          // that shouldn't live in the settings doc.
          final settingsData = settingsSnap.data()!;
          if (settingsData.containsKey('accentColor')) {
            _db
                .collection('users')
                .doc(firebaseUser.uid)
                .collection('settings')
                .doc('preferences')
                .update({'accentColor': FieldValue.delete()})
                .catchError((_) {});
          }
        } else {
          // No settings found anywhere (new user).
          // We MUST mark firestore as loaded so the app knows it can safely start
          // pushing the default local settings up to Firestore.
          ref.read(settingsProvider.notifier).markFirestoreLoaded();
        }
      } catch (e) {
        debugPrint('[Auth] Firestore settings sync error: $e');
        // Firestore fetch failed — fall back to disk so the user still sees
        // their locally cached settings instead of the in-memory defaults.
        ref.read(settingsProvider.notifier).loadFromDiskFallback();
      }
    } catch (e) {
      // Firestore sync failed — ignore silently in background
      debugPrint('[Auth] Firestore sync error: $e');
    }

    // Update state again if background sync found new data
    state = AuthState(
      user: firebaseUser,
      displayName: displayName ?? 'Pulse User',
      photoURL: (photoURL == null || photoURL.isEmpty) ? 'assets/avatars/4.jpeg' : photoURL,
      loading: false,
    );

    // Track cold launch — the lifecycle observer only fires on state *changes*,
    // so it misses the very first app open. This covers that gap.
    updateLastActive();
  }

  // ── Google Sign-In ──
  Future<void> loginWithGoogle() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      final googleSignInArgs = GoogleSignInArgs(
        clientId: 'TODO_YOUR_DESKTOP_CLIENT_ID', // Create a Desktop OAuth Client ID in Google Cloud Console
        redirectUri: 'http://localhost', // Standard redirect URI for desktop apps
        scope: 'email https://www.googleapis.com/auth/userinfo.profile',
      );
      try {
        final result = await DesktopWebviewAuth.signIn(googleSignInArgs);
        if (result == null) return;
        final credential = GoogleAuthProvider.credential(
          accessToken: result.accessToken,
        );
        await _auth.signInWithCredential(credential);
      } catch (e) {
        debugPrint('[Auth] Desktop Google Sign-in error: $e');
      }
      return;
    }

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // User cancelled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  // ── Email/Password Sign-In ──
  Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // ── Email/Password Sign-Up ──
  Future<void> signupWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Update both Firebase Auth and Firestore to prevent race conditions 
    // where _onAuthChanged writes "Pulse User" before the name is set.
    await updateUserProfile(displayName: displayName);
  }

  // ── Password Reset ──
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Update Profile (mirrors updateUserProfile in AuthContext.jsx) ──
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (photoURL != null && photoURL.isEmpty) {
      photoURL = 'assets/avatars/4.jpeg';
    }

    // Update Firebase Auth profile (skip base64 images — too large)
    if (displayName != null) await user.updateDisplayName(displayName);
    if (photoURL != null && !photoURL.startsWith('data:image')) {
      await user.updatePhotoURL(photoURL);
    }

    // Update Firestore (always includes all fields, even base64)
    final updates = <String, dynamic>{
      'lastUpdated': FieldValue.serverTimestamp(),
    };
    if (displayName != null) updates['displayName'] = displayName;
    if (photoURL != null) updates['photoURL'] = photoURL;

    await _db.collection('users').doc(user.uid).set(
          updates,
          SetOptions(merge: true),
        );

    // Live-sync avatar and name changes to support_channels for the Admin dashboard
    final supportChannelUpdates = <String, dynamic>{};
    if (displayName != null) supportChannelUpdates['userName'] = displayName;
    if (photoURL != null) supportChannelUpdates['userPhotoURL'] = photoURL;
    
    if (supportChannelUpdates.isNotEmpty) {
      try {
        await _db.collection('support_channels').doc(user.uid).update(
          supportChannelUpdates,
        );
      } catch (e) {
        // This will throw if the document doesn't exist (i.e. user never started a chat).
        // That's exactly what we want, so we just log it and move on.
        debugPrint('[LiveSync] Skipped or failed to update support_channels: $e');
      }
    }

    // Update local state
    state = state.copyWith(
      displayName: displayName ?? state.displayName,
      photoURL: photoURL ?? state.photoURL,
    );
  }

  // ── Update Last Active Time ──
  DateTime? _lastActiveUpdate;
  Future<void> updateLastActive() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    // Throttle updates to once every 5 minutes to save Firestore writes
    if (_lastActiveUpdate != null && now.difference(_lastActiveUpdate!).inMinutes < 5) {
      return;
    }
    
    _lastActiveUpdate = now;

    try {
      await _db.collection('users').doc(user.uid).set(
        {'lastActiveAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('[Auth] Failed to update lastActiveAt: $e');
    }
  }

  // ── Update Playback Stats (Direct to Firestore) ──
  Future<void> updatePlaybackStats({
    required String videoId,
    required int secondsListened,
    required String title,
    required String artist,
    String cover = '',
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Cap seconds per event (like backend MAX_SECONDS_PER_EVENT = 120)
    final actualSeconds = secondsListened > 120 ? 120 : secondsListened;
    if (actualSeconds <= 0) return;

    final date = DateTime.now().toIso8601String().split('T')[0];
    final artistKeyRaw = (artist.isEmpty ? 'unknown' : artist)
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final artistKey = artistKeyRaw.length > 100 ? artistKeyRaw.substring(0, 100) : artistKeyRaw;

    try {
      final batch = _db.batch();
      
      // 1. Daily listening bucket
      final statsRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('listeningStats')
          .doc(date);
          
      batch.set(statsRef, {
        'date': date,
        'totalSeconds': FieldValue.increment(actualSeconds),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 1b. Root user document (lifetime totals)
      final userRef = _db.collection('users').doc(user.uid);
      batch.set(userRef, {
        'lifetimeTotalSeconds': FieldValue.increment(actualSeconds),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 2. Per-song stats
      final songRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('songStats')
          .doc(videoId);
          
      batch.set(songRef, {
        'videoId': videoId,
        'title': title,
        'artist': artist,
        'cover': cover,
        'totalSeconds': FieldValue.increment(actualSeconds),
        'playCount': FieldValue.increment(1),
        'lastPlayedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 3. Per-artist stats
      final artistRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('artistStats')
          .doc(artistKey.isEmpty ? 'unknown' : artistKey);
          
      batch.set(artistRef, {
        'artistKey': artistKey.isEmpty ? 'unknown' : artistKey,
        'artist': artist,
        'cover': cover,
        'totalSeconds': FieldValue.increment(actualSeconds),
        'playCount': FieldValue.increment(1),
        'lastPlayedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();
      debugPrint('[Auth] Stats written: videoId=$videoId, seconds=$actualSeconds, artist=$artist');
      
      // 4. Update History (separately to not fail the stats batch)
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .doc(videoId)
          .set({
        'videoId': videoId,
        'playedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
    } catch (e) {
      // ignore: avoid_print
      debugPrint('[Auth] Direct stats update failed: $e');
    }
  }

  // ── Logout ──
  Future<void> logout() async {
    if (kIsWeb || (!Platform.isWindows && !Platform.isLinux)) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}

// ── Provider Registration ───────────────────────────────────────────────────

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

