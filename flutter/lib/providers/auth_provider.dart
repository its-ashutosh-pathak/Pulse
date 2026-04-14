import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/api/api_client.dart';
import '../core/constants/api_constants.dart';

// ── Auth State ──────────────────────────────────────────────────────────────

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

    // Sync Firestore profile (mirrors lines 16-39 of AuthContext.jsx)
    String? displayName = firebaseUser.displayName;
    String? photoURL = firebaseUser.photoURL;

    try {
      final ref = _db.collection('users').doc(firebaseUser.uid);
      final snap = await ref.get();

      if (!snap.exists) {
        await ref.set({
          'uid': firebaseUser.uid,
          'displayName': firebaseUser.displayName ?? 'Pulse User',
          'email': firebaseUser.email,
          'photoURL': firebaseUser.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        final data = snap.data()!;
        // Prefer Firestore profile data over Firebase Auth data
        if (data['displayName'] != null) displayName = data['displayName'];
        if (data['photoURL'] != null) photoURL = data['photoURL'];
      }
    } catch (e) {
      // Firestore sync failed — still allow auth to succeed
      // ignore: avoid_print
      print('[Auth] Firestore sync error: $e');
    }

    state = AuthState(
      user: firebaseUser,
      displayName: displayName ?? 'Pulse User',
      photoURL: photoURL,
      loading: false,
    );
  }

  // ── Google Sign-In ──
  Future<void> loginWithGoogle() async {
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
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user?.updateDisplayName(displayName);
  }

  // ── Update Profile (mirrors updateUserProfile in AuthContext.jsx) ──
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

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

    // Update local state
    state = state.copyWith(
      displayName: displayName ?? state.displayName,
      photoURL: photoURL ?? state.photoURL,
    );
  }

  // ── Update Playback Stats (mirrors updatePlaybackStats in AuthContext.jsx) ──
  Future<void> updatePlaybackStats({
    required String videoId,
    required int secondsListened,
    required String title,
    required String artist,
    String cover = '',
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await ApiClient.instance.dio.post(
        ApiConstants.statsPlay,
        data: {
          'videoId': videoId,
          'secondsListened': secondsListened,
          'date': DateTime.now().toIso8601String().split('T')[0],
          'title': title,
          'artist': artist,
          'cover': cover,
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('[Auth] Stats update failed: $e');
    }
  }

  // ── Logout ──
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

// ── Provider Registration ───────────────────────────────────────────────────

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
