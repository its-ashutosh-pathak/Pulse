import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../core/utils/formatters.dart';
import '../data/models/song.dart';

/// Reusable song list tile — used in search, library, playlist, downloads, etc.
class SongTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final thumbUrl = ThumbnailUtils.getHighRes(song.thumbnail, size: 120);

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
              if (index != null)
                SizedBox(
                  width: 28,
                  child: Text(
                    '${index! + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPlaying
                          ? Theme.of(context).colorScheme.primary
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
                      // Playing overlay
                      if (isPlaying)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Icon(
                              Icons.equalizer,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
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
