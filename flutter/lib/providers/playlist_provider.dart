import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/song.dart';
import '../data/models/playlist.dart';
import 'auth_provider.dart';

// ── Playlist State ──────────────────────────────────────────────────────────

class PlaylistState {
  final List<Playlist> playlists;
  final bool loading;

  const PlaylistState({
    this.playlists = const [],
    this.loading = true,
  });

  PlaylistState copyWith({
    List<Playlist>? playlists,
    bool? loading,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      loading: loading ?? this.loading,
    );
  }
}

// FIX #2 from React: Firestore doc limit is 1MB (~3500 songs max)
const _maxSongsPerDoc = 3500;

// ── Playlist Provider ───────────────────────────────────────────────────────

/// Port of PlaylistContext.jsx — real-time Firestore sync, CRUD, likes.
class PlaylistNotifier extends Notifier<PlaylistState> {
  StreamSubscription? _firestoreSub;
  final _db = FirebaseFirestore.instance;

  // FIX #12: Debounced lastPlayedAt (10-second window)
  Timer? _lastPlayedTimer;

  @override
  PlaylistState build() {
    // Watch auth state — re-subscribe when user changes
    final auth = ref.watch(authProvider);
    _subscribe(auth.user?.uid);

    ref.onDispose(() {
      _firestoreSub?.cancel();
      _lastPlayedTimer?.cancel();
    });

    return const PlaylistState(loading: true);
  }

  void _subscribe(String? userId) {
    _firestoreSub?.cancel();

    if (userId == null) {
      state = const PlaylistState(playlists: [], loading: false);
      return;
    }

    // Real-time Firestore listener (matches lines 44-63 of PlaylistContext.jsx)
    final query = _db
        .collection('playlists')
        .where('members', arrayContains: userId);

    _firestoreSub = query.snapshots().listen(
      (snapshot) {
        final playlists = snapshot.docs.map((doc) {
          final data = doc.data();
          final songs = (data['songs'] as List<dynamic>?)
                  ?.map((s) => Song.fromJson(Map<String, dynamic>.from(s as Map)))
                  .toList() ??
              [];

          return Playlist(
            id: doc.id,
            name: data['name']?.toString() ?? 'Playlist',
            description: data['description']?.toString(),
            thumbnail: data['thumbnail']?.toString(),
            createdBy: data['createdBy']?.toString() ?? '',
            ownerName: data['ownerName']?.toString() ?? '',
            members: (data['members'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
            songs: songs,
            visibility: data['visibility']?.toString() ?? 'Public',
            type: 'PULSE',
          );
        }).toList();

        // Sort by lastPlayedAt (most recent first), fallback to createdAt
        playlists.sort((a, b) {
          // Documents don't have DateTime fields directly, use snapshot data
          final aDoc = snapshot.docs.firstWhere((d) => d.id == a.id).data();
          final bDoc = snapshot.docs.firstWhere((d) => d.id == b.id).data();
          final tA = (aDoc['lastPlayedAt'] as Timestamp?)?.millisecondsSinceEpoch ??
              (aDoc['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ??
              0;
          final tB = (bDoc['lastPlayedAt'] as Timestamp?)?.millisecondsSinceEpoch ??
              (bDoc['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ??
              0;
          return tB.compareTo(tA);
        });

        state = PlaylistState(playlists: playlists, loading: false);
      },
      onError: (e) {
        // ignore: avoid_print
        print('[Playlist] Sync error: $e');
        state = state.copyWith(loading: false);
      },
    );
  }

  // ── Create Playlist ──
  Future<String?> createPlaylist({String name = 'New Playlist'}) async {
    final auth = ref.read(authProvider);
    if (auth.user == null) return null;

    try {
      final docRef = await _db.collection('playlists').add({
        'name': name,
        'createdBy': auth.user!.uid,
        'ownerName': auth.displayName ?? 'Pulse User',
        'members': [auth.user!.uid],
        'songs': [],
        'visibility': 'Public',
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      // ignore: avoid_print
      print('[Playlist] Create error: $e');
      return null;
    }
  }

  // ── Add Song ──
  Future<void> addSongToPlaylist(String playlistId, Song song) async {
    final auth = ref.read(authProvider);
    if (auth.user == null) return;

    try {
      final ref2 = _db.collection('playlists').doc(playlistId);
      final snap = await ref2.get();
      final currentSongs = (snap.data()?['songs'] as List?) ?? [];

      // FIX #2: Guard against Firestore 1MB limit
      if (currentSongs.length >= _maxSongsPerDoc) {
        throw Exception(
          'Playlist limit reached ($_maxSongsPerDoc songs). Please create a new playlist.',
        );
      }

      await ref2.update({
        'songs': FieldValue.arrayUnion([
          {
            ...song.toJson(),
            'addedByUid': auth.user!.uid,
            'addedByName': auth.displayName ?? 'Member',
          }
        ]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('[Playlist] Add song error: $e');
      rethrow;
    }
  }

  // ── Copy Playlist ──
  Future<String?> copyPlaylist(
    String sourceId,
    List<Song> sourceSongs,
    String sourceName,
  ) async {
    final auth = ref.read(authProvider);
    if (auth.user == null) return null;

    try {
      final docRef = await _db.collection('playlists').add({
        'name': sourceName,
        'createdBy': auth.user!.uid,
        'ownerName': auth.displayName ?? 'Pulse User',
        'members': [auth.user!.uid],
        'songs': [],
        'visibility': 'Public',
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      await _db.collection('playlists').doc(docRef.id).update({
        'songs': sourceSongs
            .map((s) => {
                  ...s.toJson(),
                  'addedByUid': auth.user!.uid,
                  'addedByName': auth.displayName ?? 'Pulse User',
                })
            .toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      // ignore: avoid_print
      print('[Playlist] Copy error: $e');
      return null;
    }
  }

  // ── Remove Song by Index ──
  Future<void> removeSongFromPlaylist(String playlistId, int songIndex) async {
    try {
      final playlist = state.playlists.firstWhere((p) => p.id == playlistId);
      final newSongs = List<Song>.from(playlist.songs);
      if (songIndex < 0 || songIndex >= newSongs.length) return;
      newSongs.removeAt(songIndex);

      await _db.collection('playlists').doc(playlistId).update({
        'songs': newSongs.map((s) => s.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('[Playlist] Remove song error: $e');
    }
  }

  // ── Update Playlist Fields ──
  Future<void> updatePlaylist(
    String playlistId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _db.collection('playlists').doc(playlistId).update({
        ...updates,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('[Playlist] Update error: $e');
    }
  }

  // ── Delete Playlist ──
  Future<void> deletePlaylist(String playlistId) async {
    try {
      await _db.collection('playlists').doc(playlistId).delete();
    } catch (e) {
      // ignore: avoid_print
      print('[Playlist] Delete error: $e');
    }
  }

  // ── Last Played (10s debounce — matches lines 214-233 of PlaylistContext.jsx) ──
  void updateLastPlayed(String playlistId) {
    _lastPlayedTimer?.cancel();
    _lastPlayedTimer = Timer(const Duration(seconds: 10), () async {
      try {
        await _db.collection('playlists').doc(playlistId).update({
          'lastPlayedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        // ignore: avoid_print
        print('[Playlist] lastPlayedAt update failed: $e');
      }
    });
  }

  // ── Liked Songs ──

  Playlist? get _likedPlaylist {
    final auth = ref.read(authProvider);
    if (auth.user == null) return null;
    try {
      return state.playlists.firstWhere(
        (p) => p.name == 'Liked Songs' && p.createdBy == auth.user!.uid,
      );
    } catch (_) {
      return null;
    }
  }

  bool isLiked(String? songId) {
    if (songId == null) return false;
    final liked = _likedPlaylist;
    if (liked == null) return false;
    return liked.songs.any((s) => s.id == songId || s.videoId == songId);
  }

  Future<void> toggleLike(Song song) async {
    final auth = ref.read(authProvider);
    if (auth.user == null) return;

    var liked = _likedPlaylist;

    // Create Liked Songs playlist if it doesn't exist
    if (liked == null) {
      try {
        final docRef = await _db.collection('playlists').add({
          'name': 'Liked Songs',
          'createdBy': auth.user!.uid,
          'ownerName': auth.displayName ?? 'Pulse User',
          'members': [auth.user!.uid],
          'songs': [],
          'visibility': 'Private',
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        // Use temporary object until Firestore snapshot updates
        liked = Playlist(id: docRef.id, name: 'Liked Songs', songs: const []);
      } catch (e) {
        // ignore: avoid_print
        print('[Playlist] Failed to create Liked Songs: $e');
        return;
      }
    }

    final index = liked.songs.indexWhere(
      (s) => s.id == song.id || s.videoId == song.id,
    );

    if (index >= 0) {
      // Unlike — remove
      await removeSongFromPlaylist(liked.id, index);
    } else {
      // Like — add
      await addSongToPlaylist(liked.id, song);
    }
  }
}

// ── Provider Registration ───────────────────────────────────────────────────

final playlistProvider = NotifierProvider<PlaylistNotifier, PlaylistState>(
  PlaylistNotifier.new,
);
