import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/music_api.dart';
import '../data/models/song.dart';

/// Search state — retains query, results, suggestions, and history
/// across tab switches (mirrors Search.jsx behavior from the PWA).
class SearchState {
  final String query;
  final bool isSearching;
  final bool showSuggestions;
  final List<String> suggestions;
  final Map<String, List<Song>> results;
  final List<Song> history;

  const SearchState({
    this.query = '',
    this.isSearching = false,
    this.showSuggestions = false,
    this.suggestions = const [],
    this.results = const {
      'songs': [], 'albums': [], 'playlists': [], 'artists': [],
    },
    this.history = const [],
  });

  SearchState copyWith({
    String? query,
    bool? isSearching,
    bool? showSuggestions,
    List<String>? suggestions,
    Map<String, List<Song>>? results,
    List<Song>? history,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      suggestions: suggestions ?? this.suggestions,
      results: results ?? this.results,
      history: history ?? this.history,
    );
  }

  bool get hasResults =>
      (results['songs']?.length ?? 0) +
          (results['albums']?.length ?? 0) +
          (results['playlists']?.length ?? 0) +
          (results['artists']?.length ?? 0) >
      0;
}

/// Notifier that manages search query, results, suggestions, and history.
/// Persists search history to SharedPreferences (mirrors localStorage in PWA).
/// Caches results in memory so navigating away and back retains them.
class SearchNotifier extends Notifier<SearchState> {
  final _musicApi = MusicApi();
  Timer? _searchTimer;
  Timer? _suggestTimer;

  /// In-memory cache of search results keyed by query (mirrors sessionStorage).
  final Map<String, Map<String, List<Song>>> _resultCache = {};

  static const _historyKey = 'pulse_search_history';
  static const _maxHistory = 10;

  @override
  SearchState build() {
    ref.onDispose(() {
      _searchTimer?.cancel();
      _suggestTimer?.cancel();
    });
    // Load history asynchronously
    _loadHistory();
    return const SearchState();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_historyKey);
      if (raw != null) {
        final list = (jsonDecode(raw) as List<dynamic>)
            .map((e) => Song.fromJson(e as Map<String, dynamic>))
            .toList();
        state = state.copyWith(history: list);
      }
    } catch (_) {}
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(state.history.map((s) => s.toJson()).toList());
      await prefs.setString(_historyKey, json);
    } catch (_) {}
  }

  /// Called when user types in the search field.
  void onQueryChanged(String q) {
    _searchTimer?.cancel();
    _suggestTimer?.cancel();

    if (q.trim().isEmpty) {
      state = state.copyWith(
        query: '',
        results: const {'songs': [], 'albums': [], 'playlists': [], 'artists': []},
        suggestions: const [],
        isSearching: false,
        showSuggestions: false,
      );
      return;
    }

    state = state.copyWith(
      query: q,
      isSearching: true,
      showSuggestions: true,
    );

    // Restore cached results instantly (mirrors sessionStorage in PWA)
    if (_resultCache.containsKey(q)) {
      state = state.copyWith(
        results: _resultCache[q]!,
        isSearching: false,
        showSuggestions: false,
      );
      return;
    }

    // Suggestions (200ms debounce)
    _suggestTimer = Timer(const Duration(milliseconds: 200), () async {
      try {
        final sugg = await _musicApi.getSuggestions(q);
        if (state.query == q) {
          state = state.copyWith(suggestions: sugg.take(8).toList());
        }
      } catch (_) {}
    });

    // Search (550ms debounce)
    _searchTimer = Timer(const Duration(milliseconds: 550), () async {
      try {
        state = state.copyWith(showSuggestions: false);
        final data = await _musicApi.searchAll(q);
        if (state.query == q) {
          final newResults = {
            'songs': (data['songs'] as List<dynamic>?)?.cast<Song>().toList() ?? [],
            'albums': (data['albums'] as List<dynamic>?)?.cast<Song>().toList() ?? [],
            'playlists': (data['playlists'] as List<dynamic>?)?.cast<Song>().toList() ?? [],
            'artists': (data['artists'] as List<dynamic>?)?.cast<Song>().toList() ?? [],
          };
          // Cache results
          _resultCache[q] = newResults;
          state = state.copyWith(results: newResults, isSearching: false);
        }
      } catch (_) {
        if (state.query == q) {
          state = state.copyWith(isSearching: false);
        }
      }
    });
  }

  /// Called when user selects a suggestion.
  void selectSuggestion(String suggestion) {
    state = state.copyWith(
      suggestions: const [],
      showSuggestions: false,
    );
    onQueryChanged(suggestion);
  }

  /// Clear query and results.
  void clearQuery() {
    _searchTimer?.cancel();
    _suggestTimer?.cancel();
    state = state.copyWith(
      query: '',
      results: const {'songs': [], 'albums': [], 'playlists': [], 'artists': []},
      suggestions: const [],
      isSearching: false,
      showSuggestions: false,
    );
  }

  /// Add a played song to search history (mirrors PWA behavior).
  void addToHistory(Song song) {
    final vid = song.videoId.isNotEmpty ? song.videoId : song.id;
    final filtered = state.history
        .where((s) => (s.videoId.isNotEmpty ? s.videoId : s.id) != vid)
        .toList();
    final newHistory = [song, ...filtered].take(_maxHistory).toList();
    state = state.copyWith(history: newHistory);
    _saveHistory();
  }

  /// Clear all search history.
  void clearHistory() {
    state = state.copyWith(history: const []);
    _saveHistory();
  }

  /// Remove a single item from history.
  void removeFromHistory(int index) {
    final newHistory = [...state.history]..removeAt(index);
    state = state.copyWith(history: newHistory);
    _saveHistory();
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
