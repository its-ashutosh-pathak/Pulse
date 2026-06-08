import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../providers/playlist_provider.dart';
import '../../widgets/glass_container.dart';

/// Import Playlist screen — port of ImportPlaylist.jsx.
/// Paste YT Music / Spotify URLs to import playlists.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _urlC = TextEditingController();
  final _musicApi = MusicApi();
  String _status = 'idle'; // idle | loading | preview | importing | done | error
  String _errorMsg = '';
  String _playlistName = '';
  List<Song> _previewSongs = [];
  int _importedCount = 0;

  @override
  void dispose() {
    _urlC.dispose();
    super.dispose();
  }

  String? _extractPlaylistId(String url) {
    // YT Music playlist URLs
    final ytmRegex = RegExp(r'list=([A-Za-z0-9_-]+)');
    final ytmMatch = ytmRegex.firstMatch(url);
    if (ytmMatch != null) return ytmMatch.group(1);

    // Direct playlist IDs
    if (url.startsWith('VL') || url.startsWith('PL') || url.startsWith('RD')) {
      return url.trim();
    }

    return null;
  }

  Future<void> _fetchPreview() async {
    final url = _urlC.text.trim();
    if (url.isEmpty) return;

    final playlistId = _extractPlaylistId(url);
    if (playlistId == null) {
      setState(() { _status = 'error'; _errorMsg = 'Invalid playlist URL or ID.'; });
      return;
    }

    setState(() { _status = 'loading'; _errorMsg = ''; });
    try {
      final playlist = await _musicApi.getPlaylist(playlistId, full: true);
      if (mounted) {
        setState(() {
          _playlistName = playlist.name;
          _previewSongs = playlist.songs;
          _status = 'preview';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'error';
          _errorMsg = 'Failed to load playlist. Check the URL and try again.';
        });
      }
    }
  }

  Future<void> _importPlaylist() async {
    if (_previewSongs.isEmpty) return;

    setState(() { _status = 'importing'; _importedCount = 0; });
    try {
      final notifier = ref.read(playlistProvider.notifier);
      final newId = await notifier.createPlaylist(name: _playlistName);

      if (newId != null) {
        for (int i = 0; i < _previewSongs.length; i++) {
          await notifier.addSongToPlaylist(newId, _previewSongs[i]);
          if (mounted) setState(() => _importedCount = i + 1);
        }
      }

      if (mounted) {
        setState(() => _status = 'done');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'error';
          _errorMsg = 'Import failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            // ── Header ──
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(LucideIcons.arrowLeft, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text('Import Playlist',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),

            const SizedBox(height: 24),

            // ── Instructions ──
            GlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.music2, size: 18, color: accent),
                      const SizedBox(width: 8),
                      const Text('Import from YouTube Music',
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Paste a YouTube Music playlist URL or playlist ID to import it into your Pulse library.',
                    style: TextStyle(fontSize: 12,
                        color: AppColors.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── URL Input ──
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Icon(LucideIcons.link, size: 16,
                        color: AppColors.textSecondary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _urlC,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'https://music.youtube.com/playlist?list=...',
                        hintStyle: TextStyle(fontSize: 12,
                            color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Fetch Button ──
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _status == 'loading' ? null : _fetchPreview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _status == 'loading'
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Fetch Playlist',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),

            // ── Error ──
            if (_status == 'error') ...[
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: 10,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(LucideIcons.alertCircle, size: 16,
                        color: AppColors.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMsg,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.danger)),
                    ),
                  ],
                ),
              ),
            ],

            // ── Preview ──
            if (_status == 'preview' || _status == 'importing' || _status == 'done') ...[
              const SizedBox(height: 20),
              GlassContainer(
                borderRadius: 14,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_playlistName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('${_previewSongs.length} tracks',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),

                    // Song previews
                    ...(_previewSongs.take(5).map((song) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.music, size: 12,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(song.title,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13)),
                          ),
                          Text(song.artist,
                              style: const TextStyle(fontSize: 11,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ))),

                    if (_previewSongs.length > 5)
                      Text('...and ${_previewSongs.length - 5} more',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),

                    const SizedBox(height: 16),

                    // Import button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _status == 'importing' || _status == 'done'
                            ? null : _importPlaylist,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _status == 'done'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.check, size: 18,
                                      color: Colors.white),
                                  const SizedBox(width: 6),
                                  const Text('Imported!',
                                      style: TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              )
                            : _status == 'importing'
                                ? Text(
                                    'Importing $_importedCount/${_previewSongs.length}...',
                                    style: const TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w600))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(LucideIcons.download, size: 16,
                                          color: Colors.white),
                                      const SizedBox(width: 6),
                                      const Text('Import to Library',
                                          style: TextStyle(fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
