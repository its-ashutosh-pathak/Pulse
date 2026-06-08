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
  final List<Map<String, dynamic>> topArtists;
  final bool loading;

  const StatsState({
    this.totalMs = 0,
    this.dailyAvgMinutes = 0,
    this.lifetimeMs = 0,
    this.topSongs = const [],
    this.topArtists = const [],
    this.loading = false,
  });

  StatsState copyWith({
    int? totalMs,
    int? dailyAvgMinutes,
    int? lifetimeMs,
    List<Map<String, dynamic>>? topSongs,
    List<Map<String, dynamic>>? topArtists,
    bool? loading,
  }) {
    return StatsState(
      totalMs: totalMs ?? this.totalMs,
      dailyAvgMinutes: dailyAvgMinutes ?? this.dailyAvgMinutes,
      lifetimeMs: lifetimeMs ?? this.lifetimeMs,
      topSongs: topSongs ?? this.topSongs,
      topArtists: topArtists ?? this.topArtists,
      loading: loading ?? this.loading,
    );
  }
}

class StatsNotifier extends Notifier<StatsState> {
  final _db = FirebaseFirestore.instance;
  DateTime? _lastLoaded;
  String? _lastTimeframe;

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
    final lifeSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('listeningStats').get(),
      'listeningStats (all)',
    );
    final periodSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('listeningStats')
          .where('date', isGreaterThanOrEqualTo: cutoffString).get(),
      'listeningStats (period)',
    );
    final songSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('songStats')
          .orderBy('playCount', descending: true).limit(10).get(),
      'songStats',
    );
    final artistSnap = await _safeGet(
      _db.collection('users').doc(uid).collection('artistStats')
          .orderBy('totalSeconds', descending: true).limit(10).get(),
      'artistStats',
    );

    debugPrint('[Stats] Results — life:${lifeSnap?.docs.length ?? 'null'}, period:${periodSnap?.docs.length ?? 'null'}, songs:${songSnap?.docs.length ?? 'null'}, artists:${artistSnap?.docs.length ?? 'null'}');

    // Lifetime stats
    int lifetimeSeconds = 0;
    final List<String> allDates = [];
    if (lifeSnap != null) {
      for (final doc in lifeSnap.docs) {
        final d = doc.data();
        lifetimeSeconds += ((d['totalSeconds'] ?? 0) as num).toInt();
        if (d['date'] != null) allDates.add(d['date'] as String);
      }
    }
    int accountDays = 1;
    if (allDates.length >= 2) {
      allDates.sort();
      accountDays =
          DateTime.parse(allDates.last).difference(DateTime.parse(allDates.first)).inDays + 1;
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
    final topSongs = songSnap?.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      // UI reads s['thumbnail'] first, but we store as 'cover'
      data['thumbnail'] ??= data['cover'] ?? '';
      return data;
    }).toList() ?? [];

    // Map top artists — ensure 'thumbnail' key exists for UI compatibility
    final topArtists = artistSnap?.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      data['thumbnail'] ??= data['cover'] ?? '';
      return data;
    }).toList() ?? [];

    _lastLoaded = DateTime.now();
    _lastTimeframe = timeframe;

    state = state.copyWith(
      totalMs: periodSeconds * 1000,
      dailyAvgMinutes: dailyAvgMinutes,
      lifetimeMs: lifetimeSeconds * 1000,
      topSongs: topSongs,
      topArtists: topArtists,
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

