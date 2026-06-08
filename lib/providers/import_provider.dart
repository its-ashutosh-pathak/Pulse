import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportTask {
  final String id;
  final String url;
  final String name;
  final int totalSongs;
  final int processedSongs;
  final String status; // 'fetching', 'matching', 'saving', 'done', 'error'
  final bool isSpotify;

  ImportTask({
    required this.id,
    required this.url,
    required this.name,
    this.totalSongs = 0,
    this.processedSongs = 0,
    this.status = 'fetching',
    required this.isSpotify,
  });

  ImportTask copyWith({
    String? name,
    int? totalSongs,
    int? processedSongs,
    String? status,
  }) {
    return ImportTask(
      id: id,
      url: url,
      name: name ?? this.name,
      totalSongs: totalSongs ?? this.totalSongs,
      processedSongs: processedSongs ?? this.processedSongs,
      status: status ?? this.status,
      isSpotify: isSpotify,
    );
  }
}

class ImportNotifier extends StateNotifier<Map<String, ImportTask>> {
  final Ref _ref;

  ImportNotifier(this._ref) : super({});

  Future<void> startImport(String url) async {
    // Temporarily disabled / Coming Soon
  }

  void _updateTask(String taskId, {String? name, int? totalSongs, int? processedSongs, String? status}) {
    if (!state.containsKey(taskId)) return;
    state = {
      ...state,
      taskId: state[taskId]!.copyWith(
        name: name,
        totalSongs: totalSongs,
        processedSongs: processedSongs,
        status: status,
      )
    };
  }

  void dismissTask(String taskId) {
    final newState = {...state};
    newState.remove(taskId);
    state = newState;
  }
}

final importProvider = StateNotifierProvider<ImportNotifier, Map<String, ImportTask>>((ref) {
  return ImportNotifier(ref);
});

