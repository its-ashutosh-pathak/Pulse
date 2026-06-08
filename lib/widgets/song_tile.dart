import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../core/utils/formatters.dart';
import '../data/models/song.dart';
import 'playing_bars.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/download_provider.dart';
import '../providers/audio_provider.dart';

/// Reusable song list tile — used in search, library, playlist, downloads, etc.
class SongTile extends ConsumerWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final bool isPlaying;
  final bool showDuration;
  final int? index; // For numbered lists

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.trailing,
    this.isPlaying = false,
    this.showDuration = false,
    this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbUrl = ThumbnailUtils.getHighRes(song.thumbnail, size: 120);
    final accent = Theme.of(context).colorScheme.primary;
    final audio = ref.watch(audioProvider);
    final downloads = ref.watch(downloadProvider);
    final isDownloading = downloads.activeDownloads.containsKey(song.videoId);
    final downloadProgress = isDownloading ? downloads.activeDownloads[song.videoId]!.progress : 0.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              // ── Index number (optional) ──
              // Always show the number; playing state shown exclusively on cover art.
              if (index != null)
                SizedBox(
                  width: 28,
                  child: Text(
                    '${index! + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      // Highlight with accent when playing so user still knows
                      color: isPlaying
                          ? accent
                          : AppColors.textSecondary,
                    ),
                  ),
                ),

              // ── Thumbnail ──
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      thumbUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: thumbUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: AppColors.surface,
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.surface,
                                child: const Icon(
                                  Icons.music_note,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.surface,
                              child: const Icon(
                                Icons.music_note,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                      // ── Downloading overlay ──
                      if (isDownloading)
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                            ),
                            child: FractionallySizedBox(
                              heightFactor: downloadProgress.clamp(0.0, 1.0),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: accent.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      // ── Playing overlay: always show animated bars on cover art ──
                      if (isPlaying)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: PlayingBars(color: accent, height: 18, isPaused: !audio.isPlaying),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── Title + Artist ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isPlaying
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Duration (optional) ──
              if (showDuration && song.duration > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    formatDuration(song.duration),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

              // ── Trailing widget (more button, etc.) ──
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
