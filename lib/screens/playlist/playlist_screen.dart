import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../data/models/playlist.dart';
import '../../providers/audio_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/download_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/song_tile.dart';
import '../../widgets/song_action_sheet.dart';
import 'package:share_plus/share_plus.dart';


/// Playlist/Album screen — pixel-perfect port of PlaylistView.jsx.
/// Handles both Firestore playlists and YTM playlists/albums.
class PlaylistScreen extends ConsumerStatefulWidget {
  final String playlistId;
  const PlaylistScreen({super.key, required this.playlistId});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  final _musicApi = MusicApi();
  Playlist? _ytmPlaylist;
  Playlist? _offlinePlaylist;
  bool _ytmLoading = false;
  bool _offlineLoading = false;
  bool _ytmError = false;
  String _trackFilter = '';
  String _sortKey = 'recent';
  String _sortOrder = 'desc';
  bool _showSortDropdown = false;

  @override
  void initState() {
    super.initState();
    _fetchYtmIfNeeded();
  }

  @override
  void didUpdateWidget(covariant PlaylistScreen old) {
    super.didUpdateWidget(old);
    if (old.playlistId != widget.playlistId) {
      _ytmPlaylist = null;
      _fetchYtmIfNeeded();
    }
  }

  void _fetchYtmIfNeeded() {
    final id = widget.playlistId;

    if (id == '__downloads__') {
      setState(() { _offlineLoading = true; _ytmError = false; });
      ref.read(downloadProvider.notifier).getAllDownloadedSongs().then((songs) {
        final pl = Playlist(id: id, name: 'Downloads', type: 'OFFLINE_PLAYLIST', songs: songs, thumbnail: songs.isNotEmpty ? songs.first.thumbnail : null);
        if (mounted) setState(() { _offlinePlaylist = pl; _offlineLoading = false; });
      });
      return;
    }

    if (id.startsWith('__pl__')) {
      setState(() { _offlineLoading = true; _ytmError = false; });
      ref.read(downloadProvider.notifier).getAllOfflinePlaylists().then((lists) {
        final pl = lists.firstWhere((p) => p.id == id, orElse: () => Playlist(id: id, name: 'Offline Playlist'));
        if (mounted) setState(() { _offlinePlaylist = pl; _offlineLoading = false; });
      }).catchError((_) {
        if (mounted) setState(() { _ytmError = true; _offlineLoading = false; });
      });
      return;
    }

    // Don't fetch YTM for Firestore IDs
    final isYtm = ['VL', 'PL', 'RD', 'OL', 'MPRE'].any((p) => id.startsWith(p));
    if (!isYtm) return;

    setState(() { _ytmLoading = true; _ytmError = false; });
    _musicApi.getPlaylist(id, full: true).then((pl) {
      if (mounted) setState(() { _ytmPlaylist = pl; _ytmLoading = false; });
    }).catchError((_) {
      if (mounted) setState(() { _ytmError = true; _ytmLoading = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistProvider);
    final audio = ref.watch(audioProvider);
    final auth = ref.watch(authProvider);
    final accent = Theme.of(context).colorScheme.primary;

    // Source: Firestore playlist or YTM playlist or Offline playlist
    final isOffline = widget.playlistId.startsWith('__pl__') || widget.playlistId == '__downloads__';
    final firestorePlaylist = playlistState.playlists.cast<dynamic>().firstWhere(
      (p) => p.id == widget.playlistId, orElse: () => null,
    );

    // Still loading YTM?
    if (firestorePlaylist == null && _ytmLoading) {
      return _buildLoading(context);
    }
    // Still loading Offline?
    if (isOffline && _offlineLoading) {
      return _buildLoading(context);
    }

    // Error
    if (firestorePlaylist == null && _ytmError) {
      return _buildError(context);
    }

    final isYtm = firestorePlaylist == null && _ytmPlaylist != null;
    final playlist = isOffline ? _offlinePlaylist : (isYtm ? _ytmPlaylist : firestorePlaylist);

    final sourceName = playlist?.name ?? '';
    final sourceSongs = (playlist?.songs as List<dynamic>?)
        ?.map((s) => s is Song ? s : Song.fromJson(s as Map<String, dynamic>))
        .toList() ?? <Song>[];
    final isOwner = !isYtm && !isOffline && firestorePlaylist?.createdBy == auth.user?.uid;

    // Filter & sort
    var songsToRender = List<Song>.from(sourceSongs);
    if (_trackFilter.isNotEmpty) {
      final q = _trackFilter.toLowerCase();
      songsToRender = songsToRender.where((s) =>
          s.title.toLowerCase().contains(q) ||
          s.artist.toLowerCase().contains(q)).toList();
    }
    if (_sortKey == 'alpha') {
      songsToRender.sort((a, b) {
        final cmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        return _sortOrder == 'desc' ? cmp : -cmp;
      });
    } else {
      if (_sortOrder == 'asc') {
        songsToRender = songsToRender.reversed.toList();
      }
    }

    // Stats
    final totalMinutes = (sourceSongs.length * 3.5).round();
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    final durationText = hours > 0 ? '${hours}h ${mins}min' : '${mins}min';

    // Cover thumbnail
    final coverThumb = isYtm
        ? ThumbnailUtils.getHighRes(_ytmPlaylist!.thumbnail ?? '', size: 800)
        : (sourceSongs.isNotEmpty
            ? ThumbnailUtils.getHighRes(sourceSongs.first.thumbnail, size: 400)
            : '');

    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
        child: GestureDetector(
          onTap: () => setState(() => _showSortDropdown = false),
          child: Column(
            children: [
              // ── Top Bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(LucideIcons.arrowLeft, size: 22),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.search,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: 'Find on this page',
                                  hintStyle: TextStyle(
                                      fontSize: 13, color: AppColors.textSecondary),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (v) => setState(() => _trackFilter = v),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 130, height: 130,
                        child: sourceSongs.length >= 4 && !isYtm
                            ? _buildQuadCover(sourceSongs.take(4).toList())
                            : (coverThumb.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: coverThumb, fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) =>
                                        Container(color: AppColors.surface))
                                : Container(color: AppColors.surface)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sourceName,
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(LucideIcons.globe,
                                  size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('${sourceSongs.length} songs • $durationText',
                                  style: const TextStyle(
                                      fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Sort
                    GestureDetector(
                      onTap: () => setState(() =>
                          _showSortDropdown = !_showSortDropdown),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.surface,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.arrowUpDown,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(_sortKey == 'alpha' ? 'A-Z' : 'Recent',
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.textSecondary)),
                            const SizedBox(width: 4),
                            Icon(
                              _sortOrder == 'asc'
                                  ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                              size: 14, color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isOffline) ...[
                      // Download — batch download all songs
                      GestureDetector(
                        onTap: () => _downloadAllSongs(sourceSongs),
                        child: const Icon(LucideIcons.download, size: 20, color: AppColors.textSecondary),
                      ),
                      if (!isYtm && !isOffline) ...[
                        const SizedBox(width: 16),
                        // Share
                        GestureDetector(
                          onTap: () => _sharePlaylist(sourceName, isYtm),
                          child: const Icon(LucideIcons.share2, size: 20, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                    const Spacer(),
                    // Shuffle
                    GestureDetector(
                      onTap: () =>
                          ref.read(audioProvider.notifier).toggleShuffle(),
                      child: Icon(LucideIcons.shuffle, size: 20,
                          color: audio.isShuffled
                              ? accent : AppColors.textSecondary),
                    ),
                    const SizedBox(width: 16),
                    // Play All — filled circle button matching PWA
                    GestureDetector(
                      onTap: () {
                        if (songsToRender.isEmpty) return;
                        final notifier = ref.read(audioProvider.notifier);
                        notifier.playSong(songsToRender.first, contextPlaylistId: widget.playlistId);
                        notifier.replaceQueue(songsToRender.skip(1).toList());
                      },
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            accent, AppColors.computeSecondary(accent),
                          ]),
                        ),
                        child: const Icon(Icons.play_arrow_rounded, size: 28,
                            color: AppColors.background),
                      ),
                    ),
                  ],
                ),
              ),



              // ── Song List ──
              Expanded(
                child: Stack(
                  children: [
                    songsToRender.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.music, size: 40,
                                    color: AppColors.textSecondary),
                                const SizedBox(height: 12),
                                Text(
                                  _trackFilter.isNotEmpty
                                      ? 'No matches found.'
                                      : isYtm
                                          ? 'No tracks in this playlist.'
                                          : 'No songs yet.',
                                  style: const TextStyle(
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: songsToRender.length,
                            itemBuilder: (context, i) {
                              final song = songsToRender[i];
                              final isActive =
                                  audio.currentSong?.videoId == song.videoId;
                              // For album tracks, fall back to playlist cover when song has no thumbnail
                              final songWithThumb = song.thumbnail.isEmpty && coverThumb.isNotEmpty
                                  ? song.copyWith(thumbnail: coverThumb)
                                  : song;
                              return SongTile(
                                song: songWithThumb,
                                isPlaying: isActive,
                                index: i,
                                onTap: () {
                                  final notifier = ref.read(audioProvider.notifier);
                                  notifier.playSong(songWithThumb, contextPlaylistId: widget.playlistId);
                                  notifier.replaceQueue(
                                      songsToRender.sublist(i + 1));
                                },
                                onLongPress: () => _showMenu(song, i, isOwner),
                                trailing: GestureDetector(
                                  onTap: () => _showMenu(song, i, isOwner),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(LucideIcons.moreVertical,
                                        size: 16, color: AppColors.textSecondary),
                                  ),
                                ),
                              );
                            },
                          ),

                    // ── Sort Dropdown Overlay ──
                    if (_showSortDropdown)
                      Positioned(
                        top: 8,
                        left: 20,
                        child: GlassContainer(
                          borderRadius: 12,
                          child: SizedBox(
                            width: 170,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _sortOption('Recently Added', 'recent', accent),
                                _sortOption('Alphabetical', 'alpha', accent),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortOption(String label, String key, Color accent) {
    final isActive = _sortKey == key;
    return InkWell(
      onTap: () {
        if (_sortKey == key) {
          setState(() => _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc');
        } else {
          setState(() { _sortKey = key; _sortOrder = 'desc'; });
        }
        setState(() => _showSortDropdown = false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? accent : AppColors.textPrimary)),
            if (isActive)
              Icon(_sortOrder == 'asc' ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                  size: 14, color: accent),
          ],
        ),
      ),
    );
  }

  Widget _buildQuadCover(List<Song> songs) {
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: songs.map((s) {
        final url = ThumbnailUtils.getHighRes(s.thumbnail, size: 120);
        return url.isNotEmpty
            ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.surface))
            : Container(color: AppColors.surface);
      }).toList(),
    );
  }

  void _downloadAllSongs(List<Song> songs) {
    final downloads = ref.read(downloadProvider.notifier);
    
    final isOffline = widget.playlistId.startsWith('__pl__') || widget.playlistId == '__downloads__';
    final firestorePlaylist = ref.read(playlistProvider).playlists.cast<dynamic>().firstWhere(
      (p) => p.id == widget.playlistId, orElse: () => null,
    );
    final isYtm = _ytmPlaylist != null && firestorePlaylist == null;
    final playlist = isOffline ? _offlinePlaylist : (isYtm ? _ytmPlaylist : firestorePlaylist);

    for (final song in songs) {
      downloads.downloadSong(song, contextPlaylist: playlist);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting download for ${songs.length} song${songs.length > 1 ? 's' : ''}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sharePlaylist(String name, bool isYtm) {
    final id = widget.playlistId;
    final url = 'https://pulse.app/playlist/$id';
    Share.share('Check out "$name" on Pulse!\n$url');
  }

  void _showMenu(Song song, int index, bool isOwner) {
    final isOffline = widget.playlistId.startsWith('__pl__') || widget.playlistId == '__downloads__';
    final isDownloadsPlaylist = widget.playlistId == '__downloads__';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SongActionSheet(
        song: song,
        showRemove: isOwner && !isOffline,
        onRemove: () {
          ref.read(playlistProvider.notifier)
              .removeSongFromPlaylist(widget.playlistId, index);
        },
        showRemoveDownload: isOffline,
        onRemoveDownload: () async {
          if (isDownloadsPlaylist) {
            // Delete from device memory entirely
            await ref.read(downloadProvider.notifier).deleteDownload(song.videoId);
          } else {
            // Just remove from this offline playlist
            final currentSongs = _offlinePlaylist?.songs
                .where((s) => s.videoId != song.videoId)
                .map((s) => s.videoId)
                .toList() ?? [];
            await ref.read(downloadProvider.notifier).updateOfflinePlaylistSongs(
              widget.playlistId, currentSongs,
            );
          }
          // Refresh
          _fetchYtmIfNeeded();
        },
      ),
    );
  }



  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(LucideIcons.arrowLeft, size: 22),
                ),
              ),
            ),
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couldn't load this playlist.",
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('← Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
