import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/song.dart';
import '../data/models/playlist.dart';
import 'auth_provider.dart';
import '../data/local/download_db.dart';
import 'download_provider.dart';
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
            createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
            lastPlayedAt: (data['lastPlayedAt'] as Timestamp?)?.toDate(),
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
          final aDoc = snapshot.docs.firstWhere((d) => d.id == a.id).data();
          final bDoc = snapshot.docs.firstWhere((d) => d.id == b.id).data();
          
          int getMs(Map<String, dynamic> doc, String field) {
            final val = doc[field];
            if (val is Timestamp) return val.millisecondsSinceEpoch;
            return 0; // If it's a FieldValue (pending write) or null, return 0
          }
          
          final tA = getMs(aDoc, 'lastPlayedAt') > 0 ? getMs(aDoc, 'lastPlayedAt') : getMs(aDoc, 'createdAt');
          final tB = getMs(bDoc, 'lastPlayedAt') > 0 ? getMs(bDoc, 'lastPlayedAt') : getMs(bDoc, 'createdAt');
          
          return tB.compareTo(tA);
        });

        state = PlaylistState(playlists: playlists, loading: false);
      },
      onError: (e) {
        // ignore: avoid_print
        debugPrint('[Playlist] Sync error: $e');
        state = state.copyWith(loading: false);
      },
    );
  }

  // ── Create Playlist ──
  Future<String?> createPlaylist({String name = 'New Playlist', List<Song> initialSongs = const []}) async {
    final auth = ref.read(authProvider);
    if (auth.user == null) return null;

    try {
      final docRef = await _db.collection('playlists').add({
        'name': name,
        'createdBy': auth.user!.uid,
        'ownerName': auth.displayName ?? 'Pulse User',
        'members': [auth.user!.uid],
        'songs': initialSongs.map((s) => <String, dynamic>{
          ...s.toJson(),
          'addedByUid': auth.user!.uid,
          'addedByName': auth.displayName ?? 'Pulse User',
        }).toList(),
        'visibility': 'Public',
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      // ignore: avoid_print
      debugPrint('[Playlist] Create error: $e');
      rethrow;
    }
  }

  // ── Import Pulse Playlist ──
  Future<String?> importPulsePlaylist(String pulseId) async {
    final auth = ref.read(authProvider);
    if (auth.user == null) return null;

    try {
      final snap = await _db.collection('playlists').doc(pulseId).get();
      if (!snap.exists) return null;

      final data = snap.data()!;
      final songsList = (data['songs'] as List?) ?? [];
      final originalName = data['name'] as String? ?? 'Imported Playlist';
      final newName = '$originalName (Imported)';

      final docRef = await _db.collection('playlists').add({
        'name': newName,
        'createdBy': auth.user!.uid,
        'ownerName': auth.displayName ?? 'Pulse User',
        'members': [auth.user!.uid],
        'songs': songsList,
        'visibility': 'Public',
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      debugPrint('[Playlist] Import error: $e');
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

      // 1. Sync to offline playlist immediately (Natively Offline)
      try {
        final downloadNotifier = ref.read(downloadProvider.notifier);
        final isDownloaded = await downloadNotifier.isDownloaded(song.videoId);
        if (isDownloaded) {
          final playlistName = snap.data()?['name'] ?? 'Playlist';
          await DownloadDb.instance.addTrackToPlaylist(
            '__pl__$playlistId',
            playlistName,
            song.videoId,
          );
        }
      } catch (e) {
        debugPrint('[Playlist] Offline sync error: $e');
      }

      // 2. Sync to Firestore in the background (No await)
      ref2.update({
        'songs': FieldValue.arrayUnion([
          {
            ...song.toJson(),
            'addedByUid': auth.user!.uid,
            'addedByName': auth.displayName ?? 'Member',
          }
        ]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }).catchError((e) {
        debugPrint('[Playlist] Background sync error: $e');
      });
    } catch (e) {
      // ignore: avoid_print
      debugPrint('[Playlist] Add song error: $e');
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
            .map((s) => <String, dynamic>{
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
      debugPrint('[Playlist] Copy error: $e');
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

      if (newSongs.isEmpty) {
        await deletePlaylist(playlistId);
        return;
      }

      // 1. Sync removal with offline DB immediately (Natively Offline)
      try {
        final downloadedSongs = await DownloadDb.instance.getAllTracks();
        final downloadedIds = downloadedSongs.map((s) => s.videoId).toSet();
        final offlineVideoIds = newSongs
            .map((s) => s.videoId)
            .where((id) => downloadedIds.contains(id))
            .toList();
        await DownloadDb.instance.updateOfflinePlaylistSongs('__pl__$playlistId', offlineVideoIds);
      } catch (e) {
        debugPrint('[Playlist] Offline sync error: $e');
      }

      // 2. Sync to Firestore in the background (No await)
      _db.collection('playlists').doc(playlistId).update({
        'songs': newSongs.map((s) => s.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }).catchError((e) {
        debugPrint('[Playlist] Background sync error: $e');
      });
    } catch (e) {
      // ignore: avoid_print
      debugPrint('[Playlist] Remove song error: $e');
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
      debugPrint('[Playlist] Update error: $e');
    }
  }

  // ── Delete Playlist ──
  Future<void> deletePlaylist(String playlistId) async {
    try {
      // 1. Delete offline playlist first (Natively Offline)
      try {
        await DownloadDb.instance.deleteOfflinePlaylist('__pl__$playlistId');
      } catch (e) {
        debugPrint('[Playlist] Offline delete error: $e');
      }

      // 2. Delete from Firestore in background
      _db.collection('playlists').doc(playlistId).delete().catchError((e) {
        debugPrint('[Playlist] Background delete error: $e');
      });
    } catch (e) {
      debugPrint('[Playlist] Delete error: $e');
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
        debugPrint('[Playlist] lastPlayedAt update failed: $e');
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
        debugPrint('[Playlist] Failed to create Liked Songs: $e');
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

