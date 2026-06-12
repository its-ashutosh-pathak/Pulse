import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/models/song.dart';
import '../../data/models/playlist.dart';
import 'package:go_router/go_router.dart';
import '../../providers/audio_provider.dart';
import '../../providers/download_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/playing_bars.dart';

/// Downloads screen — port of Downloads.jsx.
/// Shows all offline songs, play/delete per-song, clear all.
class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

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

  String _sortKey = 'recent';
  String _sortOrder = 'desc';
  bool _gridView = false;
  bool _showSortDropdown = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadSongs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _gridView = prefs.getBool('pulse_dl_view_mode_grid') ?? false;
      _sortKey = prefs.getString('pulse_dl_sort_key') ?? 'recent';
      _sortOrder = prefs.getString('pulse_dl_sort_order') ?? 'desc';
    });
    _applySorting();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pulse_dl_view_mode_grid', _gridView);
    await prefs.setString('pulse_dl_sort_key', _sortKey);
    await prefs.setString('pulse_dl_sort_order', _sortOrder);
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

      final validPlaylists = playlists.where((pl) => pl.songs.isNotEmpty).toList();
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
  }

  void _applySorting() {
    var playlists = List<Playlist>.from(_baseOfflinePlaylists);
    
    Playlist? downloadsPlaylist;
    final dlIdx = playlists.indexWhere((p) => p.id == '__downloads__');
    if (dlIdx != -1) {
      downloadsPlaylist = playlists.removeAt(dlIdx);
    }

    if (_sortKey == 'alpha') {
      playlists.sort((a, b) {
        final cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return _sortOrder == 'desc' ? cmp : -cmp;
      });
    } else {
      if (_sortOrder == 'asc') {
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

  void _handleSort(String key) {
    if (_sortKey == key) {
      setState(() => _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc');
    } else {
      setState(() { _sortKey = key; _sortOrder = 'desc'; });
    }
    setState(() => _showSortDropdown = false);
    _applySorting();
    _savePrefs();
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Downloads',
                          style: Theme.of(context).textTheme.headlineLarge),
                      Row(
                        children: [
                          // Sort button
                          _SortButton(
                            sortKey: _sortKey,
                            sortOrder: _sortOrder,
                            onTapMenu: () => setState(() =>
                                _showSortDropdown = !_showSortDropdown),
                            onTapToggle: () => _handleSort(_sortKey),
                          ),
                          const SizedBox(width: 4),
                          // View toggle
                          GestureDetector(
                            onTap: () {
                              setState(() => _gridView = !_gridView);
                              _savePrefs();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                _gridView ? LucideIcons.list : LucideIcons.layoutGrid,
                                size: 18, color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Stats and Actions ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      Icon(LucideIcons.hardDrive,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${_songs.length} songs • ${_formatSize(downloads.totalSizeBytes)}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                // ── Offline Playlists ──
                // if (_offlinePlaylists.isNotEmpty) _buildOfflinePlaylists(),



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
                                  const Text('No offline songs yet',
                                      style: TextStyle(
                                          color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  const Text(
                                      'Songs you download will appear here',
                                      style: TextStyle(fontSize: 12,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            )
                          : _gridView
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

            // ── Sort Dropdown Overlay ──
            if (_showSortDropdown)
              Positioned(
                top: 60,
                right: 20,
                child: GlassContainer(
                  borderRadius: 12,
                  child: SizedBox(
                    width: 170,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SortOption(
                          label: 'Recently Added', isActive: _sortKey == 'recent',
                          sortOrder: _sortOrder,
                          onTap: () => _handleSort('recent'),
                        ),
                        _SortOption(
                          label: 'Alphabetical', isActive: _sortKey == 'alpha',
                          sortOrder: _sortOrder,
                          onTap: () => _handleSort('alpha'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

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
                          const Text('Clear All Downloads?',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(
                            'This will remove ${_songs.length} songs and free up ${_formatSize(downloads.totalSizeBytes)} of storage.',
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
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.danger),
                                onPressed: _clearAll,
                                child: const Text('Clear All'),
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
        ),
      ),
    );
  }


  Widget _buildListView(AudioState audio) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120),
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
          title: Text(pl.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text('${pl.songs.length} songs', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
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
                        Text(pl.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('${pl.songs.length} songs', maxLines: 1, overflow: TextOverflow.ellipsis,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => GlassContainer(
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
                    Navigator.pop(context);
                    if (pl.id == '__downloads__') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot rename the master downloads playlist.')),
                      );
                    } else {
                      _renameController.text = pl.name;
                      setState(() { _editingPlaylist = pl; _showRenameModal = true; });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Icon(LucideIcons.edit2, size: 17), SizedBox(width: 14),
                      Text('Rename', style: TextStyle(fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    final songs = (pl.songs as List<dynamic>)
                        .map((s) => s is Song ? s : Song.fromJson(s as Map<String, dynamic>))
                        .toList();
                    setState(() {
                      _editSongsPlaylist = pl;
                      _editSongsList = List<Song>.from(songs);
                      _showEditSongsModal = true;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Icon(LucideIcons.listMusic, size: 17), SizedBox(width: 14),
                      Text('Edit Songs', style: TextStyle(fontSize: 15)),
                    ]),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() { _editingPlaylist = pl; _showDeleteModal = true; });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Icon(LucideIcons.trash2, size: 17, color: AppColors.danger), SizedBox(width: 14),
                      Text('Delete', style: TextStyle(fontSize: 15, color: AppColors.danger)),
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
                const Text('Rename Playlist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Enter a new name for your playlist.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                      child: const Text('Cancel'),
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
                      child: const Text('Rename'),
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
                const Text('Delete Playlist?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete "${_editingPlaylist?.name}"? This playlist will be lost forever.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _showDeleteModal = false),
                      child: const Text('Cancel'),
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
                      child: const Text('Delete'),
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                              const Text('Edit Songs',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(
                                '${_editSongsList.length} song${_editSongsList.length != 1 ? 's' : ''}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => setState(() => _showEditSongsModal = false),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: AppColors.background),
                                onPressed: () async {
                                  if (_editSongsPlaylist != null) {
                                    if (_editSongsPlaylist!.id == '__downloads__') {
                                      final originalSongs = (_editSongsPlaylist!.songs as List<dynamic>)
                                          .map((s) => s is Song ? s : Song.fromJson(s as Map<String, dynamic>))
                                          .toList();
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
                                child: const Text('Save'),
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
                          ? const Padding(
                              padding: EdgeInsets.all(32),
                              child: Text('No songs in this playlist.',
                                  style: TextStyle(color: AppColors.textSecondary)),
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

class _SortButton extends StatelessWidget {
  final String sortKey;
  final String sortOrder;
  final VoidCallback onTapMenu;
  final VoidCallback onTapToggle;

  const _SortButton({
    required this.sortKey, required this.sortOrder, required this.onTapMenu, required this.onTapToggle});

  @override
  Widget build(BuildContext context) {
    final label = sortKey == 'alpha' ? 'A-Z' : 'Recent';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTapMenu,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 4),
              child: Row(
                children: [
                  const Icon(LucideIcons.arrowUpDown, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onTapToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8, right: 12),
              child: Icon(sortOrder == 'asc' ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                  size: 14, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label; final bool isActive; final String sortOrder; final VoidCallback onTap;
  const _SortOption({
    required this.label, required this.isActive, required this.sortOrder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(
                fontSize: 14, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Theme.of(context).colorScheme.primary : AppColors.textPrimary)),
            if (isActive)
              Icon(sortOrder == 'asc' ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                  size: 14, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
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

