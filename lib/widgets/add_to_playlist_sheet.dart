import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../data/models/song.dart';
import '../providers/playlist_provider.dart';
import 'glass_container.dart';
import '../main.dart' show scaffoldMessengerKey;

/// Add-to-playlist bottom sheet — port of AddToPlaylistModal.jsx.
/// Shows the user's playlists and lets them add a song to one.
class AddToPlaylistSheet extends ConsumerWidget {
  final Song song;

  const AddToPlaylistSheet({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistState = ref.watch(playlistProvider);
    final playlists = playlistState.playlists;
    final accent = Theme.of(context).colorScheme.primary;

    return GlassContainer(
      borderRadius: 24,
      blur: 24,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ──
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(LucideIcons.plusSquare, size: 20, color: accent),
                  const SizedBox(width: 10),
                  const Text('Add to Playlist',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            const Divider(height: 24, indent: 20, endIndent: 20),

            // ── New Playlist Button ──
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final notifier = ref.read(playlistProvider.notifier);
                  Navigator.pop(context);
                  _showCreatePlaylistDialog(context, notifier);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(LucideIcons.plus, color: accent),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'New Playlist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Playlist list ──
            if (playlists.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text('No playlists yet',
                    style: TextStyle(color: AppColors.textSecondary)),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, i) {
                    final pl = playlists[i];
                    final songCount = pl.songs.length;
                    final alreadyAdded = pl.songs.any((s) =>
                        s.videoId == song.videoId || s.id == song.id);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: alreadyAdded
                            ? null
                            : () async {
                                await ref
                                    .read(playlistProvider.notifier)
                                    .addSongToPlaylist(pl.id, song);
                                if (context.mounted) Navigator.pop(context);
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 48, height: 48,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: pl.songs.length >= 4
                                            ? _QuadCover(songs: pl.songs.take(4).toList())
                                            : (pl.songs.isNotEmpty || (pl.thumbnail != null && pl.thumbnail!.isNotEmpty)
                                                ? CachedNetworkImage(
                                                    imageUrl: ThumbnailUtils.getHighRes(
                                                      (pl.thumbnail != null && pl.thumbnail!.isNotEmpty) 
                                                          ? pl.thumbnail! 
                                                          : pl.songs.first.thumbnail, 
                                                      size: 120),
                                                    fit: BoxFit.cover,
                                                    errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                                                : Container(
                                                    color: AppColors.surface,
                                                    child: Icon(
                                                      LucideIcons.listMusic,
                                                      size: 20,
                                                      color: AppColors.textSecondary,
                                                    ),
                                                  )),
                                      ),
                                      if (alreadyAdded)
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.black54,
                                            child: Icon(LucideIcons.check, color: accent, size: 24),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pl.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: alreadyAdded
                                                ? accent
                                                : AppColors.textPrimary)),
                                    Text('$songCount songs',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              if (alreadyAdded)
                                Icon(LucideIcons.checkCircle2,
                                    size: 18, color: accent),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context, PlaylistNotifier notifier) {
    final controller = TextEditingController();
    final accent = Theme.of(context).colorScheme.primary;

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: GlassContainer(
            borderRadius: 24, blur: 24,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New Playlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Playlist Name',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accent)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Cancel', style: TextStyle(color: accent)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          Navigator.pop(ctx); // Close dialog
                          try {
                            final id = await notifier
                                .createPlaylist(name: name)
                                .timeout(const Duration(seconds: 10));
                            if (id != null) {
                              await notifier
                                  .addSongToPlaylist(id, song)
                                  .timeout(const Duration(seconds: 10));
                              if (context.mounted) {
                                Navigator.pop(context); // Close bottom sheet
                              }
                              scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBar(content: Text('Added to $name')),
                              );
                            } else {
                              scaffoldMessengerKey.currentState?.showSnackBar(
                                const SnackBar(content: Text('Failed to create playlist: Authentication error')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context); // Close bottom sheet
                            }
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(content: Text('Failed to create playlist: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: const Color(0xFF050505),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Create', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuadCover extends StatelessWidget {
  final List<Song> songs;
  const _QuadCover({required this.songs});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: songs.map((s) {
        final url = s.thumbnail.isNotEmpty ? s.thumbnail : ''; // Simple thumbnail
        return url.isNotEmpty
            ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.surface))
            : Container(color: AppColors.surface);
      }).toList(),
    );
  }
}
