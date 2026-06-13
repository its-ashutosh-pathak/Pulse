import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/spotify_parser.dart';
import '../core/theme/app_colors.dart';
import '../providers/import_provider.dart';

class SpotifyPlaylistsSheet extends ConsumerStatefulWidget {
  final String clientId;
  
  const SpotifyPlaylistsSheet({super.key, required this.clientId});

  @override
  ConsumerState<SpotifyPlaylistsSheet> createState() => _SpotifyPlaylistsSheetState();
}

class _SpotifyPlaylistsSheetState extends ConsumerState<SpotifyPlaylistsSheet> {
  List<Map<String, dynamic>>? _playlists;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    try {
      final data = await SpotifyParser.getUserPlaylists(widget.clientId);
      if (mounted) {
        setState(() {
          _playlists = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e is DioException && e.response?.data != null) {
             final responseData = e.response!.data;
             if (responseData is Map && responseData['error'] != null) {
                 final errorObj = responseData['error'];
                 if (errorObj is Map) {
                     _error = errorObj['message']?.toString() ?? e.toString();
                 } else {
                     _error = errorObj.toString();
                 }
             } else {
                 _error = 'Raw 403 Response: $responseData\n\nFallback: ${e.toString()}';
             }
          } else {
             _error = e.toString();
          }
          _loading = false;
        });
      }
    }
  }

  void _importPlaylist(String url) {
    ref.read(importProvider.notifier).startImport(url, clientId: widget.clientId);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.55;
    final accent = Theme.of(context).colorScheme.primary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Spotify Playlists',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)))
              : _error != null 
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text('Error: $_error\nMake sure your Client ID is valid.', 
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent)
                      ),
                    )
                  )
                : _playlists == null || _playlists!.isEmpty
                  ? const Center(child: Text('No playlists found in your library', style: TextStyle(color: AppColors.textSecondary)))
                  : ListView.builder(
                      itemCount: _playlists!.length,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, index) {
                        final p = _playlists![index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          leading: p['image'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(p['image'], width: 48, height: 48, fit: BoxFit.cover),
                                )
                              : Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(LucideIcons.music, color: Colors.white54),
                                ),
                          title: Text(p['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${p['tracks']} tracks', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          trailing: ElevatedButton(
                            onPressed: () => _importPlaylist(p['url']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1DB954),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Import', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
