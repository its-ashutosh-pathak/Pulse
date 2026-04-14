import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../data/models/song.dart';
import '../providers/playlist_provider.dart';
import 'glass_container.dart';

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
                              Icon(
                                LucideIcons.listMusic,
                                size: 18,
                                color: alreadyAdded
                                    ? accent
                                    : AppColors.textSecondary,
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
}
