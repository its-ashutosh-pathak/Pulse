import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/home_section.dart';
import '../data/api/music_api.dart';

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
