import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../providers/download_provider.dart';

class DownloadingScreen extends ConsumerWidget {
  const DownloadingScreen({super.key});

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 MB";
    final mb = bytes / (1024 * 1024);
    return "${mb.toStringAsFixed(1)} MB";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(downloadProvider);
    final activeDownloads = downloadState.activeDownloads.values.toList();
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Text(
                    'Downloading',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: activeDownloads.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.download, size: 48, color: AppColors.textSecondary),
                          SizedBox(height: 16),
                          Text(
                            'No active downloads',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: activeDownloads.length,
                      itemBuilder: (context, index) {
                        final download = activeDownloads[index];
                        final song = download.song;
                        if (song == null) return const SizedBox.shrink();

                        final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 120);
                        final receivedStr = _formatBytes(download.receivedBytes);
                        final totalStr = _formatBytes(download.totalBytes);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              // Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: thumb.isNotEmpty
                                      ? (!thumb.startsWith('http')
                                          ? Image.file(
                                              File(thumb),
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: thumb,
                                              fit: BoxFit.cover,
                                              errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                                            ))
                                      : Container(color: AppColors.surface),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Info and Progress
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$receivedStr / $totalStr',
                                      style: const TextStyle(
                                          fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: download.progress,
                                      backgroundColor: AppColors.surface,
                                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                                      minHeight: 4,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Actions
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 26,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      if (download.isPaused || download.error != null) {
                                        ref.read(downloadProvider.notifier).resumeDownload(download.videoId);
                                      } else {
                                        ref.read(downloadProvider.notifier).pauseDownload(download.videoId);
                                      }
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        (download.isPaused || download.error != null) ? LucideIcons.play : LucideIcons.pause,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      ref.read(downloadProvider.notifier).cancelAndRemoveDownload(download.videoId);
                                    },
                                    icon: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        LucideIcons.x,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
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
