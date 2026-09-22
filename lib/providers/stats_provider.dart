import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/music_api.dart';
import 'auth_provider.dart';

class StatsState {
  final int totalMs;
  final int dailyAvgMinutes;
  final int lifetimeMs;
  final List<Map<String, dynamic>> topSongs;
  final List<Map<String, dynamic>> recentSongs;
  final List<Map<String, dynamic>> topArtists;
  final List<Map<String, dynamic>> forgottenFavorites;
  final bool loading;

  const StatsState({
    this.totalMs = 0,
    this.dailyAvgMinutes = 0,
    this.lifetimeMs = 0,
    this.topSongs = const [],
    this.recentSongs = const [],
    this.topArtists = const [],
    this.forgottenFavorites = const [],
    this.loading = false,
  });

  StatsState copyWith({
    int? totalMs,
    int? dailyAvgMinutes,
    int? lifetimeMs,
    List<Map<String, dynamic>>? topSongs,
    List<Map<String, dynamic>>? recentSongs,
    List<Map<String, dynamic>>? topArtists,
    List<Map<String, dynamic>>? forgottenFavorites,
    bool? loading,
  }) {
    return StatsState(
      totalMs: totalMs ?? this.totalMs,
      dailyAvgMinutes: dailyAvgMinutes ?? this.dailyAvgMinutes,
      lifetimeMs: lifetimeMs ?? this.lifetimeMs,
      topSongs: topSongs ?? this.topSongs,
      recentSongs: recentSongs ?? this.recentSongs,
      topArtists: topArtists ?? this.topArtists,
      forgottenFavorites: forgottenFavorites ?? this.forgottenFavorites,
      loading: loading ?? this.loading,
    );
  }
}

class StatsNotifier extends Notifier<StatsState> {
  final _db = FirebaseFirestore.instance;
  DateTime? _lastLoaded;
  String? _lastTimeframe;
  bool _isBackfilling = false;

  @override
  StatsState build() => const StatsState();

  Future<void> loadStats(String timeframe, {bool force = false}) async {
    final user = ref.read(authProvider).user;
    if (user == null) {
      debugPrint('[Stats] No user found — skipping stats load');
      return;
    }

    // Skip if same timeframe loaded within last 5 minutes (cache hit)
    final isFresh = _lastLoaded != null &&
        _lastTimeframe == timeframe &&
        DateTime.now().difference(_lastLoaded!).inMinutes < 5;
    if (isFresh && !force && state.topSongs.isNotEmpty) return;

    // Only show spinner on very first load (no existing data)
    if (state.topSongs.isEmpty && state.topArtists.isEmpty) {
      state = state.copyWith(loading: true);
    }

    final uid = user.uid;
    debugPrint('[Stats] Loading stats for uid=$uid timeframe=$timeframe');
    final days = {'day': 0, 'week': 7, 'month': 30, 'year': 365}[timeframe] ?? 7;
    final cutoffString = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .split('T')[0];

    // Run each query independently — one failing won't kill the rest
    DocumentSnapshot<Map<String, dynamic>>? userDocSnap;
    try {
      userDocSnap = await _db.collection('users').doc(uid).get();
    } catch (e) {
      debugPrint('[Stats] user doc error: $e');
    }

    final periodSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('listeningStats')
          .where('date', isGreaterThanOrEqualTo: cutoffString).get(),
      'listeningStats (period)',
    );
    final oneMonthAgoTimestamp = Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 15)));
    final songSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('songStats')
          .where('lastPlayedAt', isGreaterThanOrEqualTo: oneMonthAgoTimestamp)
          .orderBy('lastPlayedAt', descending: true)
          .limit(100)
          .get(),
      'songStats',
    );
    final recentSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('songStats')
          .orderBy('lastPlayedAt', descending: true).limit(15).get(),
      'recentStats',
    );
    // Fetch a broad pool of all-time songs for forgotten favourites calculation.
    // We need play counts across all songs the user has ever listened to.
    final allSongsSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('songStats')
          .orderBy('playCount', descending: true)
          .limit(200)
          .get(),
      'allSongStats (forgotten)',
    );
    final artistSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('artistStats')
          .orderBy('totalSeconds', descending: true).limit(10).get(),
      'artistStats',
    );

    debugPrint('[Stats] Results — period:${periodSnap?.docs.length ?? 'null'}, songs:${songSnap?.docs.length ?? 'null'}, artists:${artistSnap?.docs.length ?? 'null'}');

    // Lifetime stats
    int lifetimeSeconds = 0;
    int accountDays = 1;
    final userData = userDocSnap?.data();

    if (userData != null && userData.containsKey('lifetimeTotalSeconds')) {
      lifetimeSeconds = ((userData['lifetimeTotalSeconds'] ?? 0) as num).toInt();
      final firstListened = userData['firstListenedDate'] as String?;
      if (firstListened != null) {
         accountDays = DateTime.now().difference(DateTime.parse(firstListened)).inDays + 1;
      } else if (userData['createdAt'] != null) {
         final created = (userData['createdAt'] as Timestamp).toDate();
         accountDays = DateTime.now().difference(created).inDays + 1;
      }
    } else {
      // Lazy backfill: compute from historical docs
      if (!_isBackfilling) {
        _isBackfilling = true;
        try {
          final lifeSnap = await _safeGet(
            _db.collection('users').doc(uid).collection('listeningStats').get(),
            'listeningStats (all)',
          );
          final List<String> allDates = [];
          if (lifeSnap != null) {
            for (final doc in lifeSnap.docs) {
              final d = doc.data();
              lifetimeSeconds += ((d['totalSeconds'] ?? 0) as num).toInt();
              if (d['date'] != null) allDates.add(d['date'] as String);
            }
          }
          if (allDates.length >= 2) {
            allDates.sort();
            accountDays = DateTime.parse(allDates.last).difference(DateTime.parse(allDates.first)).inDays + 1;
          }
          
          // Save backfill back to root doc
          try {
            final firstListenedDate = allDates.isNotEmpty ? allDates.first : DateTime.now().toIso8601String().split('T')[0];
            await _db.collection('users').doc(uid).set({
              'lifetimeTotalSeconds': lifetimeSeconds,
              'firstListenedDate': firstListenedDate,
            }, SetOptions(merge: true));
          } catch (e) {
            debugPrint('[Stats] Backfill save error: $e');
          }
        } finally {
          _isBackfilling = false;
        }
      }
    }

    final dailyAvgMinutes = accountDays > 0
        ? (lifetimeSeconds / 60 / accountDays).round()
        : 0;

    // Period stats
    int periodSeconds = timeframe == 'lifetime' ? lifetimeSeconds : 0;
    if (timeframe != 'lifetime' && periodSnap != null) {
      for (final doc in periodSnap.docs) {
        periodSeconds += ((doc.data()['totalSeconds'] ?? 0) as num).toInt();
      }
    }

    // Map top songs — ensure 'thumbnail' key exists for UI compatibility
    final topSongsUnsorted = songSnap?.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      // UI reads s['thumbnail'] first, but we store as 'cover'
      data['thumbnail'] ??= data['cover'] ?? '';
      return data;
    }).toList() ?? [];

    topSongsUnsorted.sort((a, b) => ((b['playCount'] ?? 0) as num).compareTo((a['playCount'] ?? 0) as num));
    final topSongs = topSongsUnsorted.take(18).toList();

    // Map recent songs
    final recentSongsList = recentSnap?.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      data['thumbnail'] ??= data['cover'] ?? '';
      return data;
    }).toList() ?? [];

    // Map top artists — ensure 'thumbnail' key exists for UI compatibility
    final topArtists = artistSnap?.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      data['thumbnail'] ??= data['cover'] ?? '';
      return data;
    }).toList() ?? [];

    // ── Forgotten Favourites ───────────────────────────────────────────────
    // A song is a "forgotten favourite" if:
    //   1. It hasn't been played in the last 30 days
    //   2. Its play count is above the user's personal average
    // Fallback: if fewer than 15 qualify, relax the recency window to 15 days.
    final List<Map<String, dynamic>> forgottenFavorites;
    final allSongDocs = allSongsSnap?.docs ?? [];
    if (allSongDocs.isNotEmpty) {
      final allSongMaps = allSongDocs.map((d) {
        final data = Map<String, dynamic>.from(d.data());
        data['thumbnail'] ??= data['cover'] ?? '';
        return data;
      }).toList();

      // Compute the user's average play count across all their songs
      final totalPlayCount = allSongMaps.fold<num>(
        0, (sum, s) => sum + ((s['playCount'] ?? 0) as num));
      final avgPlayCount = totalPlayCount / allSongMaps.length;

      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final fifteenDaysAgo = DateTime.now().subtract(const Duration(days: 15));

      // Helper: extract lastPlayedAt as DateTime from a song map
      DateTime? lastPlayed(Map<String, dynamic> s) {
        final raw = s['lastPlayedAt'];
        if (raw is Timestamp) return raw.toDate();
        return null;
      }

      // Primary: above average + not played in 30 days
      var forgotten = allSongMaps.where((s) {
        final lp = lastPlayed(s);
        final count = (s['playCount'] ?? 0) as num;
        return lp != null && lp.isBefore(thirtyDaysAgo) && count >= avgPlayCount;
      }).toList();

      // Fallback: relax to 15 days if we don't have enough
      if (forgotten.length < 15) {
        forgotten = allSongMaps.where((s) {
          final lp = lastPlayed(s);
          final count = (s['playCount'] ?? 0) as num;
          return lp != null && lp.isBefore(fifteenDaysAgo) && count >= avgPlayCount;
        }).toList();
      }

      // Sort by play count descending, take top 15
      forgotten.sort((a, b) =>
          ((b['playCount'] ?? 0) as num).compareTo((a['playCount'] ?? 0) as num));
      forgottenFavorites = forgotten.take(15).toList();
    } else {
      forgottenFavorites = [];
    }

    _lastLoaded = DateTime.now();
    _lastTimeframe = timeframe;

    state = state.copyWith(
      totalMs: periodSeconds * 1000,
      dailyAvgMinutes: dailyAvgMinutes,
      lifetimeMs: lifetimeSeconds * 1000,
      topSongs: topSongs,
      recentSongs: recentSongsList,
      topArtists: topArtists,
      forgottenFavorites: forgottenFavorites,
      loading: false,
    );

    // Kick off async enrichment of artists
    _enrichArtists(topArtists, timeframe);
  }

  Future<void> _enrichArtists(List<Map<String, dynamic>> artists, String timeframe) async {
    if (artists.isEmpty) return;
    
    final musicApi = MusicApi();
    final prefs = await SharedPreferences.getInstance();
    final enriched = List<Map<String, dynamic>>.from(artists);
    bool changed = false;

    for (int i = 0; i < enriched.length; i++) {
      if (_lastTimeframe != timeframe) return; // User switched timeframe
      
      final a = enriched[i];
      final name = a['artist'] ?? a['name'] ?? '';
      if (name.isEmpty || name == 'Unknown') continue;

      final cacheKey = 'pulse_artist_v5_${name.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';
      
      final cachedThumb = prefs.getString('${cacheKey}_thumb');
      final cachedId = prefs.getString('${cacheKey}_id');
      
      if (cachedThumb != null && cachedId != null) {
        if (a['thumbnail'] != cachedThumb || a['browseId'] != cachedId) {
          a['thumbnail'] = cachedThumb;
          a['browseId'] = cachedId;
          changed = true;
        }
        continue;
      }

      try {
        if (i > 0) await Future.delayed(const Duration(milliseconds: 650));
        if (_lastTimeframe != timeframe) return;
        
        final bid = await musicApi.resolveArtist(name);
        if (bid != null) {
          a['browseId'] = bid;
          final artistInfo = await musicApi.getArtist(bid);
          if (artistInfo.thumbnail.isNotEmpty) {
            a['thumbnail'] = artistInfo.thumbnail;
            await prefs.setString('${cacheKey}_thumb', artistInfo.thumbnail);
            await prefs.setString('${cacheKey}_id', bid);
            changed = true;
          }
        }
      } catch (e) {
        // Ignore errors, use whatever we had
      }
      
      if (changed && _lastTimeframe == timeframe) {
        state = state.copyWith(topArtists: List.from(enriched));
      }
    }
  }

  /// Runs a Firestore get() and returns null instead of throwing.
  Future<QuerySnapshot<Map<String, dynamic>>?> _safeGet(
      Future<QuerySnapshot<Map<String, dynamic>>> future, String label) async {
    try {
      return await future;
    } catch (e) {
      // ignore: avoid_print
      debugPrint('[Stats] Query error ($label): $e');
      return null;
    }
  }
}

final statsProvider = NotifierProvider<StatsNotifier, StatsState>(
  StatsNotifier.new,
);

