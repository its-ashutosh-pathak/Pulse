import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../data/api/music_api.dart';
import '../data/models/song.dart';
import '../providers/audio_provider.dart';
import '../providers/download_provider.dart';
import 'glass_container.dart';
import 'add_to_playlist_sheet.dart';

/// Song action bottom sheet — port of SongActionMenu.jsx.
/// Shows: Add to Queue, Add to Playlist, Go to Album, Go to Artist, Download.
class SongActionSheet extends ConsumerStatefulWidget {
  final Song song;
  final bool showRemove;
  final VoidCallback? onRemove;

  const SongActionSheet({
    super.key,
    required this.song,
    this.showRemove = false,
    this.onRemove,
  });

  @override
  ConsumerState<SongActionSheet> createState() => _SongActionSheetState();
}

class _SongActionSheetState extends ConsumerState<SongActionSheet> {
  String? _loadingAction;
  String _downloadState = 'idle'; // idle | checking | already | downloading | done | error
  final _musicApi = MusicApi();

  @override
  void initState() {
    super.initState();
    _checkDownload();
  }

  Future<void> _checkDownload() async {
    final videoId = widget.song.videoId;
    if (videoId.isEmpty) return;
    setState(() => _downloadState = 'checking');
    try {
      final downloaded =
          await ref.read(downloadProvider.notifier).isDownloaded(videoId);
      if (mounted) setState(() => _downloadState = downloaded ? 'already' : 'idle');
    } catch (_) {
      if (mounted) setState(() => _downloadState = 'idle');
    }
  }

  @override
  Widget build(BuildContext context) {
    final thumb = ThumbnailUtils.getHighRes(widget.song.thumbnail, size: 200);

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

            // ── Track info ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 48, height: 48,
                      child: thumb.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: thumb, fit: BoxFit.cover,
                              errorWidget: (_, __, ___) =>
                                  Container(color: AppColors.surface))
                          : Container(color: AppColors.surface),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.song.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(widget.song.artist,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 24, indent: 20, endIndent: 20),

            // ── Actions ──
            _ActionItem(
              icon: LucideIcons.listMusic, label: 'Add to Queue',
              onTap: () {
                ref.read(audioProvider.notifier).addToQueue(widget.song);
                Navigator.pop(context);
              },
            ),
            _ActionItem(
              icon: LucideIcons.plusSquare, label: 'Add to Playlist',
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => AddToPlaylistSheet(song: widget.song),
                );
              },
            ),
            _ActionItem(
              icon: LucideIcons.disc,
              label: _loadingAction == 'ALBUM' ? 'Finding...' : 'Go to Album',
              loading: _loadingAction == 'ALBUM',
              onTap: () => _goToAlbum(),
            ),
            _ActionItem(
              icon: LucideIcons.user,
              label: _loadingAction == 'ARTIST' ? 'Finding...' : 'Go to Artist',
              loading: _loadingAction == 'ARTIST',
              onTap: () => _goToArtist(),
            ),

            const Divider(height: 16, indent: 20, endIndent: 20),

            // ── Download ──
            _ActionItem(
              icon: _downloadIcon(),
              label: _downloadLabel(),
              loading: _downloadState == 'downloading' || _downloadState == 'checking',
              enabled: _downloadState == 'idle' || _downloadState == 'error',
              accent: _downloadState == 'done' || _downloadState == 'already',
              onTap: _handleDownload,
            ),

            // ── Remove (optional) ──
            if (widget.showRemove) ...[
              const Divider(height: 16, indent: 20, endIndent: 20),
              _ActionItem(
                icon: LucideIcons.trash2, label: 'Remove from Playlist',
                danger: true,
                onTap: () {
                  widget.onRemove?.call();
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _downloadIcon() {
    if (_downloadState == 'done' || _downloadState == 'already') {
      return LucideIcons.checkCircle2;
    }
    return LucideIcons.download;
  }

  String _downloadLabel() {
    return switch (_downloadState) {
      'checking' => 'Checking...',
      'downloading' => 'Downloading...',
      'done' => 'Downloaded!',
      'already' => 'Already downloaded',
      'error' => 'Download failed',
      _ => 'Download',
    };
  }

  Future<void> _handleDownload() async {
    if (_downloadState != 'idle' && _downloadState != 'error') return;
    setState(() => _downloadState = 'downloading');
    try {
      await ref.read(downloadProvider.notifier).downloadSong(widget.song);
      if (mounted) setState(() => _downloadState = 'done');
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _downloadState = 'error');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _downloadState = 'idle');
      }
    }
  }

  Future<void> _goToAlbum() async {
    setState(() => _loadingAction = 'ALBUM');
    try {
      // Check cached album browse ID
      final cachedId = [widget.song.albumBrowseId]
          .where((id) => id != null && id.startsWith('MPRE'))
          .firstOrNull;
      if (cachedId != null) {
        if (mounted) { Navigator.pop(context); context.push('/playlist/$cachedId'); }
        return;
      }
      // Search for album
      final albumName = widget.song.album.isNotEmpty ? widget.song.album : widget.song.title;
      final bid = await _musicApi.searchAlbum('album $albumName ${widget.song.artist}'.trim());
      if (mounted) {
        Navigator.pop(context);
        if (bid != null && bid.startsWith('MPRE')) {
          context.push('/playlist/$bid');
        } else {
          context.push('/search?q=${Uri.encodeComponent(albumName)}');
        }
      }
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        context.push('/search?q=${Uri.encodeComponent(widget.song.album)}');
      }
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }

  Future<void> _goToArtist() async {
    setState(() => _loadingAction = 'ARTIST');
    try {
      final artistId = widget.song.artistBrowseId;
      if (artistId != null && artistId.isNotEmpty) {
        if (mounted) { Navigator.pop(context); context.push('/artist/$artistId'); }
        return;
      }
      final name = widget.song.artist;
      final bid = await _musicApi.resolveArtist(name);
      if (mounted) {
        Navigator.pop(context);
        if (bid != null) {
          context.push('/artist/$bid');
        } else {
          context.push('/search?q=${Uri.encodeComponent(name)}');
        }
      }
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        context.push('/search?q=${Uri.encodeComponent(widget.song.artist)}');
      }
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }
}

// ── Action item row ──
class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final bool enabled;
  final bool danger;
  final bool accent;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.loading = false,
    this.enabled = true,
    this.danger = false,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? AppColors.danger
        : accent
            ? Theme.of(context).colorScheme.primary
            : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && !loading ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              if (loading)
                SizedBox(
                  width: 17, height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                )
              else
                Icon(icon, size: 17, color: color),
              const SizedBox(width: 14),
              Text(label, style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
