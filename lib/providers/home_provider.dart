import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/home_section.dart';
import '../data/models/song.dart';
import '../data/api/music_api.dart';
import 'package:flutter/foundation.dart';
import '../data/models/artist.dart';

class HomeState {
  final List<HomeSection> sections;
  final bool loading;
  final bool error;

  const HomeState({
    this.sections = const [],
    this.loading = true,
    this.error = false,
  });

  HomeState copyWith({
    List<HomeSection>? sections,
    bool? loading,
    bool? error,
  }) {
    return HomeState(
      sections: sections ?? this.sections,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  final _musicApi = MusicApi();

  @override
  HomeState build() {
    return const HomeState();
  }

  Future<void> loadHome({bool forceRefresh = false}) async {
    if (!forceRefresh && state.sections.isNotEmpty) {
      return; // Use cached data
    }

    state = state.copyWith(loading: true, error: false);

    try {
      final sections = await _musicApi.getHome();
      state = state.copyWith(
        sections: sections,
        loading: false,
        error: false,
      );
    } catch (e) {
      // ignore: avoid_print
      print('[HomeProvider] Failed to load home feed: $e');
      state = state.copyWith(loading: false, error: true);
    }
  }
}

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

// ── Personalised Quick Picks ──
// Seeds getWatchNext with the user's top 5 recently played songs.
// Only fetches once per session (cached in state).
class QuickPickGroup {
  final Song seed;
  final List<Song>? songs;
  final bool hasError;
  const QuickPickGroup({required this.seed, this.songs, this.hasError = false});
  String get seedTitle => seed.title;
}

class QuickPicksState {
  final List<QuickPickGroup> groups;
  final bool loading;

  const QuickPicksState({
    this.groups = const [],
    this.loading = false,
  });
}

class QuickPicksNotifier extends Notifier<QuickPicksState> {
  final _musicApi = MusicApi();

  @override
  QuickPicksState build() => const QuickPicksState();

  Future<void> loadForRecentSongs(List<Song> recentSongs) async {
    // Already loaded — don't re-fetch in the same session
    if (state.groups.isNotEmpty) return;

    state = const QuickPicksState(loading: true);

    try {
      final uniqueSeeds = <Song>[];
      final seen = <String>{};
      for (final song in recentSongs) {
        if (!seen.contains(song.videoId)) {
          seen.add(song.videoId);
          uniqueSeeds.add(song);
          if (uniqueSeeds.length == 5) break;
        }
      }
      
      final groups = uniqueSeeds.map((seed) => QuickPickGroup(seed: seed)).toList();
      state = QuickPicksState(groups: groups, loading: false);
      
      if (groups.isNotEmpty) {
        fetchGroup(0); // Fetch the first page immediately
      }
    } catch (e) {
      // Silently fail — just don't show the section
      debugPrint('[QuickPicks] Failed to load: $e');
      state = const QuickPicksState(loading: false);
    }
  }

  Future<void> fetchGroup(int index) async {
    if (index < 0 || index >= state.groups.length) return;
    
    final group = state.groups[index];
    if (group.songs != null || group.hasError) return; // Already fetched or failed
    
    try {
      final related = await _musicApi.getWatchNext(group.seed.videoId);
      final filtered = related
          .where((s) => s.isPlayable && s.videoId != group.seed.videoId)
          .take(5)
          .toList();
          
      final newGroups = List<QuickPickGroup>.from(state.groups);
      newGroups[index] = QuickPickGroup(seed: group.seed, songs: filtered);
      state = QuickPicksState(groups: newGroups, loading: state.loading);
    } catch (e) {
      debugPrint('[QuickPicks] Failed to fetch group $index: $e');
      final newGroups = List<QuickPickGroup>.from(state.groups);
      newGroups[index] = QuickPickGroup(seed: group.seed, hasError: true);
      state = QuickPicksState(groups: newGroups, loading: state.loading);
    }
  }
}

final quickPicksProvider =
    NotifierProvider<QuickPicksNotifier, QuickPicksState>(
  QuickPicksNotifier.new,
);

// ── Favorite Artist ──
class FavoriteArtistGroup {
  final String artistName;
  final Artist? artistData;
  final bool hasError;
  const FavoriteArtistGroup({required this.artistName, this.artistData, this.hasError = false});
}

class FavoriteArtistState {
  final List<FavoriteArtistGroup> groups;
  final bool loading;
  
  const FavoriteArtistState({this.groups = const [], this.loading = false});
}

class FavoriteArtistNotifier extends Notifier<FavoriteArtistState> {
  final _musicApi = MusicApi();

  @override
  FavoriteArtistState build() => const FavoriteArtistState();

  Future<void> loadForRecentSongs(List<Song> recentSongs) async {
    if (state.groups.isNotEmpty) return;

    // Find top artist by name
    final artistCounts = <String, int>{};
    
    for (final song in recentSongs) {
      final name = song.artist;
      if (name.isNotEmpty && name != 'Unknown') {
        artistCounts[name] = (artistCounts[name] ?? 0) + 1;
      }
    }

    if (artistCounts.isEmpty) return;

    final sorted = artistCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sorted.take(5).map((e) => e.key).toList();

    if (top5.isEmpty) return;
    
    final groups = top5.map((name) => FavoriteArtistGroup(artistName: name)).toList();
    state = FavoriteArtistState(groups: groups, loading: false);
    
    if (groups.isNotEmpty) {
      fetchGroup(0);
    }
  }

  Future<void> fetchGroup(int index) async {
    if (index < 0 || index >= state.groups.length) return;
    
    final group = state.groups[index];
    if (group.artistData != null || group.hasError) return;
    
    try {
      final browseId = await _musicApi.resolveArtist(group.artistName);
      if (browseId != null && browseId.isNotEmpty) {
        final artist = await _musicApi.getArtist(browseId);
        final newGroups = List<FavoriteArtistGroup>.from(state.groups);
        newGroups[index] = FavoriteArtistGroup(artistName: group.artistName, artistData: artist);
        state = FavoriteArtistState(groups: newGroups, loading: state.loading);
      } else {
        final newGroups = List<FavoriteArtistGroup>.from(state.groups);
        newGroups[index] = FavoriteArtistGroup(artistName: group.artistName, hasError: true);
        state = FavoriteArtistState(groups: newGroups, loading: state.loading);
      }
    } catch (e) {
      debugPrint('[FavoriteArtist] Failed to fetch group $index: $e');
      final newGroups = List<FavoriteArtistGroup>.from(state.groups);
      newGroups[index] = FavoriteArtistGroup(artistName: group.artistName, hasError: true);
      state = FavoriteArtistState(groups: newGroups, loading: state.loading);
    }
  }
}

final favoriteArtistProvider =
    NotifierProvider<FavoriteArtistNotifier, FavoriteArtistState>(
  FavoriteArtistNotifier.new,
);
