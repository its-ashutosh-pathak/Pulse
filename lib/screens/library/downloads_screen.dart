import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/models/song.dart';
import '../../data/models/playlist.dart';
import 'package:go_router/go_router.dart';
import '../../providers/audio_provider.dart';
import '../../providers/download_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/playing_bars.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';

/// Downloads screen — port of Downloads.jsx.
/// Shows all offline songs, play/delete per-song, clear all.
class DownloadsScreen extends ConsumerStatefulWidget {
  final String sortKey;
  final String sortOrder;
  final bool gridView;

  const DownloadsScreen({
    super.key,
    required this.sortKey,
    required this.sortOrder,
    required this.gridView,
  });

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  List<Song> _songs = [];
  List<Playlist> _offlinePlaylists = [];
  List<Playlist> _baseOfflinePlaylists = [];
  bool _loading = true;
  bool _showClearConfirm = false;
  bool _showRenameModal = false;
  bool _showDeleteModal = false;
  bool _showEditSongsModal = false;
  
  Playlist? _editingPlaylist;
  Playlist? _editSongsPlaylist;
  List<Song> _editSongsList = [];
  final TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  void didUpdateWidget(DownloadsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortKey != widget.sortKey || oldWidget.sortOrder != widget.sortOrder) {
      _applySorting();
    }
  }

  Future<void> _loadSongs() async {
    setState(() => _loading = true);
    try {
      final songs =
          await ref.read(downloadProvider.notifier).getAllDownloadedSongs();
      final playlists =
          await ref.read(downloadProvider.notifier).getAllOfflinePlaylists();
      
      final globalDownloadsPlaylist = Playlist(
        id: '__downloads__',
        name: 'Downloads',
        type: 'OFFLINE_PLAYLIST',
        songs: songs,
        thumbnail: songs.isNotEmpty ? songs.first.thumbnail : null,
      );

      final validPlaylists = playlists.where((pl) => (pl.totalTracks ?? 0) > 0).toList();
      final allPlaylists = songs.isNotEmpty ? [globalDownloadsPlaylist, ...validPlaylists] : validPlaylists;

      if (mounted) {
        setState(() { _songs = songs; _baseOfflinePlaylists = allPlaylists; _loading = false; });
        _applySorting();
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }


  Future<void> _clearAll() async {
    await ref.read(downloadProvider.notifier).clearAll();
    setState(() { _songs = []; _showClearConfirm = false; });
  }  void _applySorting() {
    var playlists = List<Playlist>.from(_baseOfflinePlaylists);
    
    Playlist? downloadsPlaylist;
    final dlIdx = playlists.indexWhere((p) => p.id == '__downloads__');
    if (dlIdx != -1) {
      downloadsPlaylist = playlists.removeAt(dlIdx);
    }

    if (widget.sortKey == 'alpha') {
      playlists.sort((a, b) {
        final cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return widget.sortOrder == 'desc' ? cmp : -cmp;
      });
    } else {
      if (widget.sortOrder == 'asc') {
        playlists = playlists.reversed.toList();
      }
    }

    setState(() {
      _offlinePlaylists = [
        if (downloadsPlaylist != null) downloadsPlaylist,
        ...playlists,
      ];
    });
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(audioProvider);
    final downloads = ref.watch(downloadProvider);
    final accent = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Column(
          children: [

                // ── Stats and Actions ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      Icon(LucideIcons.hardDrive,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.downloadsStats(_songs.length.toString(), _formatSize(downloads.totalSizeBytes)),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                // ── Offline Playlists ──



                // ── Song List / Grid ──
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _songs.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.download, size: 48,
                                      color: AppColors.textSecondary
                                          .withValues(alpha: 0.3)),
                                  const SizedBox(height: 12),
                                  Text(AppLocalizations.of(context)!.downloadsNoOffline,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Text(
                                      AppLocalizations.of(context)!.downloadsNoOfflineDesc,
                                      style: const TextStyle(fontSize: 12,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            )
                          : widget.gridView
                              ? _buildGridView(audio)
                              : _buildListView(audio),
                ),
              ],
            ),

            // ── Rename Modal ──
            if (_showRenameModal) Positioned.fill(child: _buildRenameModal(accent)),

            // ── Delete Modal ──
            if (_showDeleteModal) Positioned.fill(child: _buildDeleteModal(accent)),

            // ── Edit Songs Modal ──
            if (_showEditSongsModal) Positioned.fill(child: _buildEditSongsModal(accent)),



            // ── Clear All Confirmation ──
            if (_showClearConfirm)
              GestureDetector(
                onTap: () => setState(() => _showClearConfirm = false),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: GlassContainer(
                      borderRadius: 24, blur: 24,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.trash2,
                              size: 32, color: AppColors.danger),
                          const SizedBox(height: 12),
                          Text(AppLocalizations.of(context)!.downloadsClearAllTitle,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.downloadsClearAllDesc(_songs.length.toString(), _formatSize(downloads.totalSizeBytes)),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    setState(() => _showClearConfirm = false),
                                child: Text(AppLocalizations.of(context)!.downloadsCancel),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.danger),
                                onPressed: _clearAll,
                                child: Text(AppLocalizations.of(context)!.downloadsClearAll),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
    );
  }


  Widget _buildListView(AudioState audio) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 180),
      itemCount: _offlinePlaylists.length,
      itemBuilder: (context, i) {
        final pl = _offlinePlaylists[i];
        final thumb = ThumbnailUtils.getHighRes(pl.thumbnail ?? '', size: 200);
        final songsList = (pl.songs as List<dynamic>).map((s) => s is Song ? s : Song.fromJson(s as Map<String, dynamic>)).toList();
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: songsList.length >= 4
                        ? _QuadCover(songs: songsList.take(4).toList())
                        : (thumb.isNotEmpty
                            ? (!thumb.startsWith('http')
                                ? Image.file(File(thumb), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                                : CachedNetworkImage(
                                    imageUrl: thumb, fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(color: AppColors.surface)))
                            : Container(color: AppColors.surface, child: const Icon(LucideIcons.listMusic, color: AppColors.textSecondary))),
                  ),
                  if (audio.contextPlaylistId == pl.id)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: PlayingBars(
                            color: Theme.of(context).colorScheme.primary,
                            height: 16,
                            isPaused: !audio.isPlaying,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          title: Text(pl.id == '__downloads__' ? AppLocalizations.of(context)!.downloadsPlaylistName : pl.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(AppLocalizations.of(context)!.downloadsSongsCount((pl.totalTracks ?? pl.songs.length).toString()), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          trailing: GestureDetector(
            onTap: () => _showPlaylistMenu(pl),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(LucideIcons.moreVertical, size: 18, color: AppColors.textSecondary),
            ),
          ),
          onTap: () => context.push('/playlist/${pl.id}'),
        );
      },
    );
  }

  Widget _buildGridView(AudioState audio) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 180),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 0.75,
        crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: _offlinePlaylists.length,
      itemBuilder: (context, i) {
        final pl = _offlinePlaylists[i];
        final thumb = ThumbnailUtils.getHighRes(pl.thumbnail ?? '', size: 300);
        final songsList = (pl.songs as List<dynamic>).map((s) => s is Song ? s : Song.fromJson(s as Map<String, dynamic>)).toList();
        return GestureDetector(
          onTap: () => context.push('/playlist/${pl.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: songsList.length >= 4
                              ? _QuadCover(songs: songsList.take(4).toList())
                              : (thumb.isNotEmpty
                                  ? (!thumb.startsWith('http')
                                      ? Image.file(File(thumb), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                                      : CachedNetworkImage(
                                          imageUrl: thumb, fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              Container(color: AppColors.surface)))
                                  : Container(color: AppColors.surface, child: const Icon(LucideIcons.listMusic, color: AppColors.textSecondary))),
                        ),
                        if (audio.contextPlaylistId == pl.id)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: Center(
                                child: PlayingBars(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 24,
                                  isPaused: !audio.isPlaying,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pl.id == '__downloads__' ? AppLocalizations.of(context)!.downloadsPlaylistName : pl.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text(AppLocalizations.of(context)!.downloadsSongsCount((pl.totalTracks ?? pl.songs.length).toString()), maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showPlaylistMenu(pl),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 4),
                      child: Icon(LucideIcons.moreVertical, size: 16, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlaylistMenu(Playlist pl) {
    showModalBottomSheet(useRootNavigator: true, 
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassContainer(
        borderRadius: 24, blur: 24,
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    if (pl.id == '__downloads__') {
                      ToastUtils.show(context, AppLocalizations.of(context)!.downloadsCannotRenameMaster);
                    } else {
                      _renameController.text = pl.name;
                      setState(() { _editingPlaylist = pl; _showRenameModal = true; });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      const Icon(LucideIcons.edit2, size: 17), const SizedBox(width: 14),
                      Text(AppLocalizations.of(context)!.downloadsRename, style: const TextStyle(fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(ctx);
                    List<Song> songs;
                    if (pl.id == '__downloads__') {
                      songs = pl.songs;
                    } else {
                      // Fetch lazy-loaded tracks from the database
                      songs = await ref.read(downloadProvider.notifier).getPlaylistTracks(pl.id);
                    }
                    setState(() {
                      _editSongsPlaylist = pl;
                      _editSongsList = List<Song>.from(songs);
                      _showEditSongsModal = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      const Icon(LucideIcons.listMusic, size: 17), const SizedBox(width: 14),
                      Text(AppLocalizations.of(context)!.downloadsEditSongs, style: const TextStyle(fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() { _editingPlaylist = pl; _showDeleteModal = true; });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      const Icon(LucideIcons.trash2, size: 17, color: AppColors.danger), const SizedBox(width: 14),
                      Text(AppLocalizations.of(context)!.downloadsDelete, style: const TextStyle(fontSize: 15, color: AppColors.danger)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Modals ──

  Widget _buildRenameModal(Color accent) {
    return GestureDetector(
      onTap: () => setState(() => _showRenameModal = false),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GlassContainer(
            borderRadius: 24, blur: 24,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.downloadsRenamePlaylistTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.downloadsRenamePlaylistDesc,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                TextField(
                  controller: _renameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true, fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _showRenameModal = false),
                      child: Text(AppLocalizations.of(context)!.downloadsCancel),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: AppColors.background),
                      onPressed: () async {
                        if (_editingPlaylist != null && _renameController.text.trim().isNotEmpty) {
                          await ref.read(downloadProvider.notifier).renameOfflinePlaylist(
                            _editingPlaylist!.id,
                            _renameController.text.trim(),
                          );
                          await _loadSongs();
                        }
                        if (mounted) setState(() => _showRenameModal = false);
                      },
                      child: Text(AppLocalizations.of(context)!.downloadsRename),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteModal(Color accent) {
    return GestureDetector(
      onTap: () => setState(() => _showDeleteModal = false),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GlassContainer(
            borderRadius: 24, blur: 24,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.trash2, size: 32, color: AppColors.danger),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context)!.downloadsDeletePlaylistTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  _editingPlaylist?.id == '__downloads__'
                      ? AppLocalizations.of(context)!.downloadsDeleteMasterDesc
                      : AppLocalizations.of(context)!.downloadsDeletePlaylistDesc(_editingPlaylist?.name ?? ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _showDeleteModal = false),
                      child: Text(AppLocalizations.of(context)!.downloadsCancel),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: AppColors.background),
                      onPressed: () async {
                        if (_editingPlaylist != null) {
                          if (_editingPlaylist!.id == '__downloads__') {
                            await ref.read(downloadProvider.notifier).clearAll();
                            setState(() { _songs = []; });
                          } else {
                            await ref.read(downloadProvider.notifier).deleteOfflinePlaylist(_editingPlaylist!.id);
                          }
                          await _loadSongs();
                        }
                        if (mounted) setState(() => _showDeleteModal = false);
                      },
                      child: Text(AppLocalizations.of(context)!.downloadsDelete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditSongsModal(Color accent) {
    return GestureDetector(
      onTap: () => setState(() => _showEditSongsModal = false),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // prevent close on card tap
            child: GlassContainer(
              borderRadius: 24, blur: 24,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 140),
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.downloadsEditSongs,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(
                                _editSongsList.length == 1 
                                    ? AppLocalizations.of(context)!.downloadsSongCountSingle('1') 
                                    : AppLocalizations.of(context)!.downloadsSongsCount(_editSongsList.length.toString()),
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => setState(() => _showEditSongsModal = false),
                                child: Text(AppLocalizations.of(context)!.downloadsCancel),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: AppColors.background),
                                onPressed: () async {
                                  if (_editSongsPlaylist != null) {
                                    if (_editSongsPlaylist!.id == '__downloads__') {
                                      final originalSongs = _editSongsPlaylist!.songs;
                                      final newIds = _editSongsList.map((s) => s.videoId).toSet();
                                      final removedSongs = originalSongs.where((s) => !newIds.contains(s.videoId)).toList();
                                      for (final rs in removedSongs) {
                                        await ref.read(downloadProvider.notifier).deleteDownload(rs.videoId);
                                      }
                                    } else {
                                      final videoIds = _editSongsList.map((s) => s.videoId).toList();
                                      await ref.read(downloadProvider.notifier).updateOfflinePlaylistSongs(
                                        _editSongsPlaylist!.id,
                                        videoIds,
                                      );
                                    }
                                    await _loadSongs();
                                  }
                                  if (mounted) setState(() => _showEditSongsModal = false);
                                },
                                child: Text(AppLocalizations.of(context)!.downloadsSave),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.glassBorder),
                    // Song list
                    Flexible(
                      child: _editSongsList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(AppLocalizations.of(context)!.downloadsNoSongs,
                                  style: const TextStyle(color: AppColors.textSecondary)),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _editSongsList.length,
                              itemBuilder: (context, i) {
                                final song = _editSongsList[i];
                                final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 120);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: Row(
                                    children: [
                                      // Thumbnail
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: SizedBox(
                                          width: 40, height: 40,
                                          child: thumb.isNotEmpty
                                              ? (!thumb.startsWith('http')
                                                  ? Image.file(File(thumb), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                                                  : CachedNetworkImage(
                                                      imageUrl: thumb, fit: BoxFit.cover,
                                                      errorWidget: (_, __, ___) =>
                                                          Container(color: AppColors.surface)))
                                              : Container(color: AppColors.surface),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Song info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(song.title,
                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14, fontWeight: FontWeight.w600)),
                                            Text(song.artist,
                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ),
                                      // Remove button
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _editSongsList.removeAt(i);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.danger.withValues(alpha: 0.15),
                                          ),
                                          child: const Icon(LucideIcons.trash2,
                                              size: 16, color: AppColors.danger),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ──



class _QuadCover extends StatelessWidget {
  final List<Song> songs;
  const _QuadCover({required this.songs});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: songs.map((s) {
        final url = ThumbnailUtils.getHighRes(s.thumbnail, size: 120);
        return url.isNotEmpty
            ? (!url.startsWith('http')
                ? Image.file(File(url), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                : CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(color: AppColors.surface)))
            : Container(color: AppColors.surface);
      }).toList(),
    );
  }
}

