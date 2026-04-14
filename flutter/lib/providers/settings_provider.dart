import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_client.dart';
import '../core/constants/api_constants.dart';

// ── Settings State ──────────────────────────────────────────────────────────

class SettingsState {
  final String streamingQuality; // 'automatic', 'low', 'normal', 'high'
  final String downloadQuality;
  final int crossfadeDuration; // 0-12 seconds
  final bool dataSaverMode;
  final Color accentColor;
  final String backendUrl;

  const SettingsState({
    this.streamingQuality = 'automatic',
    this.downloadQuality = 'high',
    this.crossfadeDuration = 0,
    this.dataSaverMode = false,
    this.accentColor = const Color(0xFF865AA4),
    this.backendUrl = ApiConstants.defaultBaseUrl,
  });

  SettingsState copyWith({
    String? streamingQuality,
    String? downloadQuality,
    int? crossfadeDuration,
    bool? dataSaverMode,
    Color? accentColor,
    String? backendUrl,
  }) {
    return SettingsState(
      streamingQuality: streamingQuality ?? this.streamingQuality,
      downloadQuality: downloadQuality ?? this.downloadQuality,
      crossfadeDuration: crossfadeDuration ?? this.crossfadeDuration,
      dataSaverMode: dataSaverMode ?? this.dataSaverMode,
      accentColor: accentColor ?? this.accentColor,
      backendUrl: backendUrl ?? this.backendUrl,
    );
  }
}

// ── Quality mapping (matches Settings.jsx toBackendQuality/toFrontendQuality) ──

String _toBackend(String q) {
  switch (q) {
    case 'automatic':
      return 'auto';
    case 'normal':
      return 'medium';
    default:
      return q;
  }
}

String _toFrontend(String q) {
  switch (q) {
    case 'auto':
      return 'automatic';
    case 'medium':
      return 'normal';
    default:
      return q;
  }
}

// ── Settings Provider ───────────────────────────────────────────────────────

/// Port of Settings.jsx state management — shared_preferences replaces localStorage.
class SettingsNotifier extends Notifier<SettingsState> {
  Timer? _syncTimer;

  @override
  SettingsState build() {
    ref.onDispose(() => _syncTimer?.cancel());
    // Load settings async after build
    Future.microtask(() => _loadFromDisk());
    return const SettingsState();
  }

  // ── Load from SharedPreferences (replaces localStorage reads in Settings.jsx) ──
  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();

    state = state.copyWith(
      streamingQuality:
          _toFrontend(prefs.getString('pulse_streaming_quality') ?? 'auto'),
      downloadQuality:
          _toFrontend(prefs.getString('pulse_download_quality') ?? 'high'),
      crossfadeDuration: prefs.getInt('pulse_crossfade') ?? 0,
      dataSaverMode: prefs.getBool('pulse_data_saver') ?? false,
      accentColor: Color(
        prefs.getInt('pulse_accent_color_int') ?? 0xFF865AA4,
      ),
      backendUrl:
          prefs.getString('pulse_backend_url') ?? ApiConstants.defaultBaseUrl,
    );

    // Apply backend URL
    ApiClient.instance.setBaseUrl(state.backendUrl);
  }

  // ── Load from backend (matches Settings.jsx useEffect on mount) ──
  Future<void> loadFromBackend() async {
    try {
      final response = await ApiClient.instance.dio.get(ApiConstants.settings);
      if (response.data['success'] == true && response.data['data'] != null) {
        final s = response.data['data'] as Map<String, dynamic>;
        if (s['streamingQuality'] != null) {
          setStreamingQuality(_toFrontend(s['streamingQuality']));
        }
        if (s['downloadQuality'] != null) {
          setDownloadQuality(_toFrontend(s['downloadQuality']));
        }
        if (s['crossfadeDuration'] != null) {
          setCrossfade(s['crossfadeDuration'] as int);
        }
        if (s['dataSaverMode'] != null) {
          setDataSaver(s['dataSaverMode'] as bool);
        }
        if (s['accentColor'] != null) {
          setAccentColor(_hexToColor(s['accentColor']));
        }
      }
    } catch (_) {
      // Backend unavailable — use local settings
    }
  }

  // ── Setters ──

  void setStreamingQuality(String quality) {
    state = state.copyWith(streamingQuality: quality);
    _persistAndSync();
  }

  void setDownloadQuality(String quality) {
    state = state.copyWith(downloadQuality: quality);
    _persistAndSync();
  }

  void setCrossfade(int seconds) {
    state = state.copyWith(crossfadeDuration: seconds.clamp(0, 12));
    _persistAndSync();
  }

  void setDataSaver(bool enabled) {
    state = state.copyWith(dataSaverMode: enabled);
    _persistAndSync();
  }

  void setAccentColor(Color color) {
    state = state.copyWith(accentColor: color);
    _persistAndSync();
  }

  void setBackendUrl(String url) {
    state = state.copyWith(backendUrl: url);
    ApiClient.instance.setBaseUrl(url);
    _persistAndSync();
  }

  // ── Persist to disk + debounced backend sync ──
  // Mirrors the 600ms debounce in Settings.jsx useEffect
  void _persistAndSync() {
    _saveToDisk();
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(milliseconds: 600), _syncToBackend);
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'pulse_streaming_quality', _toBackend(state.streamingQuality));
    await prefs.setString(
        'pulse_download_quality', _toBackend(state.downloadQuality));
    await prefs.setInt('pulse_crossfade', state.crossfadeDuration);
    await prefs.setBool('pulse_data_saver', state.dataSaverMode);
    await prefs.setInt('pulse_accent_color_int', state.accentColor.toARGB32());
    await prefs.setString('pulse_backend_url', state.backendUrl);
  }

  Future<void> _syncToBackend() async {
    try {
      await ApiClient.instance.dio.patch(
        ApiConstants.settings,
        data: {
          'streamingQuality': _toBackend(state.streamingQuality),
          'downloadQuality': _toBackend(state.downloadQuality),
          'crossfadeDuration': state.crossfadeDuration,
          'dataSaverMode': state.dataSaverMode,
          'accentColor': _colorToHex(state.accentColor),
        },
      );
    } catch (_) {
      // Backend sync failed — local state saved, will sync next time
    }
  }

  // ── Color helpers ──

  static String _colorToHex(Color c) {
    final r = (c.r * 255.0).round().clamp(0, 255);
    final g = (c.g * 255.0).round().clamp(0, 255);
    final b = (c.b * 255.0).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  static Color _hexToColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    if (clean.length != 6) return const Color(0xFF865AA4);
    return Color(int.parse('FF$clean', radix: 16));
  }
}

// ── Provider Registration ───────────────────────────────────────────────────

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
