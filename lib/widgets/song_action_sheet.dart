import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/utils/toast_utils.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../data/api/music_api.dart';
import '../data/models/song.dart';
import '../data/models/playlist.dart';
import '../providers/audio_provider.dart';
import '../providers/download_provider.dart';
import '../providers/player_overlay_provider.dart';
import '../providers/desktop_layout_provider.dart';
import 'glass_container.dart';
import 'add_to_playlist_sheet.dart';
import 'multi_artist_sheet.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';

/// Song action bottom sheet — port of SongActionMenu.jsx.
/// Shows: Add to Queue, Add to Playlist, Go to Album, Go to Artist, Download.
class SongActionSheet extends ConsumerStatefulWidget {
  final Song song;
  final bool showRemove;
  final VoidCallback? onRemove;
  final bool showRemoveDownload;
  final VoidCallback? onRemoveDownload;
  final String? removeDownloadLabel;
  final Playlist? contextPlaylist;

  const SongActionSheet({
    super.key,
    required this.song,
    this.showRemove = false,
    this.onRemove,
    this.showRemoveDownload = false,
    this.onRemoveDownload,
    this.removeDownloadLabel,
    this.contextPlaylist,
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
                          ? (!thumb.startsWith('http')
                              ? Image.file(File(thumb), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                              : CachedNetworkImage(
                                  imageUrl: thumb, fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      Container(color: AppColors.surface)))
                          : Container(color: AppColors.surface, child: const Icon(Icons.music_note, color: AppColors.textSecondary)),
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
              icon: LucideIcons.listMusic, label: AppLocalizations.of(context)!.songActionQueue,
              onTap: () {
                ref.read(audioProvider.notifier).addToQueue(widget.song);
                Navigator.pop(context);
              },
            ),
            _ActionItem(
              icon: LucideIcons.plusSquare, label: AppLocalizations.of(context)!.songActionPlaylist,
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  builder: (_) => AddToPlaylistSheet(song: widget.song),
                );
              },
            ),
            _ActionItem(
              icon: LucideIcons.disc,
              label: _loadingAction == 'ALBUM' ? AppLocalizations.of(context)!.songActionFinding : AppLocalizations.of(context)!.songActionAlbum,
              loading: _loadingAction == 'ALBUM',
              onTap: () => _goToAlbum(),
            ),
            _ActionItem(
              icon: LucideIcons.user,
              label: _loadingAction == 'ARTIST' ? AppLocalizations.of(context)!.songActionFinding : AppLocalizations.of(context)!.songActionArtist,
              loading: _loadingAction == 'ARTIST',
              onTap: () => _goToArtist(),
            ),

            const Divider(height: 16, indent: 20, endIndent: 20),

            // ── Download ──
            _ActionItem(
              icon: _downloadIcon(),
              label: _downloadLabel(context),
              loading: _downloadState == 'downloading' || _downloadState == 'checking',
              enabled: _downloadState == 'idle' || _downloadState == 'error',
              accent: _downloadState == 'done' || _downloadState == 'already',
              onTap: _handleDownload,
            ),

            // ── Remove from Playlist (optional) ──
            if (widget.showRemove) ...[
              const Divider(height: 16, indent: 20, endIndent: 20),
              _ActionItem(
                icon: LucideIcons.trash2, label: AppLocalizations.of(context)!.songActionRemovePlaylist,
                danger: true,
                onTap: () {
                  widget.onRemove?.call();
                  Navigator.pop(context);
                },
              ),
            ],

            // ── Remove from Downloads (optional) ──
            if (widget.showRemoveDownload) ...[
              if (!widget.showRemove) const Divider(height: 16, indent: 20, endIndent: 20),
              _ActionItem(
                icon: LucideIcons.trash2, label: widget.removeDownloadLabel ?? AppLocalizations.of(context)!.songActionRemoveDownload,
                danger: true,
                onTap: () {
                  widget.onRemoveDownload?.call();
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

  String _downloadLabel(BuildContext context) {
    return switch (_downloadState) {
      'checking' => AppLocalizations.of(context)!.songActionDownloadChecking,
      'downloading' => AppLocalizations.of(context)!.songActionDownloading,
      'done' => AppLocalizations.of(context)!.songActionDownloaded,
      'already' => AppLocalizations.of(context)!.songActionDownloadAlready,
      'error' => AppLocalizations.of(context)!.songActionDownloadFailed,
      _ => AppLocalizations.of(context)!.songActionDownload,
    };
  }

  void _handleDownload() {
    if (_downloadState != 'idle' && _downloadState != 'error') return;
    ref.read(downloadProvider.notifier).downloadSong(widget.song, contextPlaylist: widget.contextPlaylist);
    final accent = Theme.of(context).colorScheme.primary;
    final router = GoRouter.of(context);
    Navigator.pop(context);
    ToastUtils.show(
      context,
      AppLocalizations.of(context)!.songActionDownloadingSnack,
      action: TextButton(
        onPressed: () {
          if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
            ref.read(desktopLibraryTabProvider.notifier).state = 2;
          } else {
            router.push('/downloading');
          }
        },
        child: Text(AppLocalizations.of(context)!.songActionView, style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _goToAlbum() async {
    setState(() => _loadingAction = 'ALBUM');
    // Capture router BEFORE any await — context may be invalid after async gap + pop.
    final router = GoRouter.of(context);
    try {
      final albumId = widget.song.albumBrowseId;
      final t = DateTime.now().millisecondsSinceEpoch;

      if (albumId != null && albumId.length > 11) {
        if (mounted) {
          Navigator.pop(context);
          ref.read(playerOverlayProvider.notifier).state = false;
          // Delay push to next frame — prevents Navigator key-reservation assertion
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => router.push('/playlist/$albumId?t=$t'));
        }
        return;
      }

      if (widget.song.album.isNotEmpty) {
        final bid = await _musicApi.resolveAlbum(widget.song.album);
        if (mounted) {
          Navigator.pop(context);
          ref.read(playerOverlayProvider.notifier).state = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (bid != null) {
              router.push('/playlist/$bid?t=$t');
            } else {
              router.push('/search?q=${Uri.encodeComponent(widget.song.album)}&t=$t');
            }
          });
        }
        return;
      }
      
      // Fallback for missing album data in Feed/History sections
      if (widget.song.title.isNotEmpty) {
        final query = '${widget.song.title} ${widget.song.artist}'.trim();
        final searchResults = await _musicApi.searchSongs(query);
        if (searchResults.isNotEmpty) {
          final first = searchResults.first;
          if (first.albumBrowseId != null && first.albumBrowseId!.length > 11) {
            if (mounted) {
              Navigator.pop(context);
              ref.read(playerOverlayProvider.notifier).state = false;
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => router.push('/playlist/${first.albumBrowseId}?t=$t'));
            }
            return;
          } else if (first.album.isNotEmpty) {
            final bid = await _musicApi.resolveAlbum(first.album);
            if (mounted) {
              Navigator.pop(context);
              ref.read(playerOverlayProvider.notifier).state = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (bid != null) {
                  router.push('/playlist/$bid?t=$t');
                } else {
                  router.push('/search?q=${Uri.encodeComponent(first.album)}&t=$t');
                }
              });
            }
            return;
          }
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        final name = widget.song.album;
        if (name.isNotEmpty) {
          ref.read(playerOverlayProvider.notifier).state = false;
          final t = DateTime.now().millisecondsSinceEpoch;
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => router.push('/search?q=${Uri.encodeComponent(name)}&t=$t'));
        }
      }
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }

  Future<void> _goToArtist() async {
    final artistNames = widget.song.artist
        .split(RegExp(r',\s*|\s+&\s+|\s+feat\.?\s+|\s+ft\.?\s+', caseSensitive: false))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (artistNames.length > 1) {
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => MultiArtistSheet(artistNames: artistNames),
      );
      return;
    }

    setState(() => _loadingAction = 'ARTIST');
    // Capture router BEFORE any await — context may be invalid after async gap + pop.
    final router = GoRouter.of(context);
    try {
      String? artistId = widget.song.artistBrowseId;
      if (artistId == null || artistId.isEmpty) {
        final bid = widget.song.browseId;
        if (bid != null && (bid.startsWith('UC') || bid.startsWith('AC'))) {
          artistId = bid;
        }
      }

      final t = DateTime.now().millisecondsSinceEpoch;

      if (artistId != null && artistId.isNotEmpty) {
        if (mounted) {
          Navigator.pop(context);
          ref.read(playerOverlayProvider.notifier).state = false;
          // Delay push to next frame — prevents Navigator key-reservation assertion
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => router.push('/artist/$artistId?t=$t'));
        }
        return;
      }

      final name = widget.song.artist.isNotEmpty ? widget.song.artist : widget.song.title;
      if (name.isEmpty) {
        if (mounted) Navigator.pop(context);
        return;
      }

      final bid = await _musicApi.resolveArtist(name);
      if (mounted) {
        Navigator.pop(context);
        ref.read(playerOverlayProvider.notifier).state = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (bid != null) {
            router.push('/artist/$bid?t=$t');
          } else {
            router.push('/search?q=${Uri.encodeComponent(name)}&t=$t');
          }
        });
      }
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        ref.read(playerOverlayProvider.notifier).state = false;
        final name = widget.song.artist.isNotEmpty ? widget.song.artist : widget.song.title;
        final t = DateTime.now().millisecondsSinceEpoch;
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => router.push('/search?q=${Uri.encodeComponent(name)}&t=$t'));
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
              Flexible(
                child: Text(label, style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
