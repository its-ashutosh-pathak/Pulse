import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/models/playlist.dart';
import '../../data/models/song.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/import_provider.dart';
import '../../providers/download_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/playing_bars.dart';

/// Library screen — port of Library.jsx.
/// Shows user playlists with sort, grid/list toggle, FAB for create/import.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _sortKey = 'recent';
  String _sortOrder = 'desc';
  bool _gridView = false;
  bool _showSortDropdown = false;
  bool _showAddOptions = false;
  bool _showCreateModal = false;
  bool _showImportModal = false;
  String _selectedImportSource = 'ytmusic'; // 'ytmusic' or 'spotify'
  final _createController = TextEditingController();
  final _importUrlController = TextEditingController();

  // For rename/delete modals
  Playlist? _editingPlaylist;
  bool _showRenameModal = false;
  bool _showDeleteModal = false;
  final _renameController = TextEditingController();

  // For edit-songs modal (buffered save)
  bool _showEditSongsModal = false;
  Playlist? _editSongsPlaylist;
  List<Song> _editSongsList = [];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _gridView = prefs.getBool('pulse_lib_view_mode_grid') ?? false;
      _sortKey = prefs.getString('pulse_lib_sort_key') ?? 'recent';
      _sortOrder = prefs.getString('pulse_lib_sort_order') ?? 'desc';
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pulse_lib_view_mode_grid', _gridView);
    await prefs.setString('pulse_lib_sort_key', _sortKey);
    await prefs.setString('pulse_lib_sort_order', _sortOrder);
  }

  @override
  void dispose() {
    _createController.dispose();
    _renameController.dispose();
    _importUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistProvider);
    final importState = ref.watch(importProvider);
    final downloadState = ref.watch(downloadProvider);
    final playlists = playlistState.playlists;
    final accent = Theme.of(context).colorScheme.primary;

    final activeCount = downloadState.activeDownloads.length;
    final totalProgress = activeCount > 0 
        ? downloadState.activeDownloads.values.map((v) => v.progress).reduce((a, b) => a + b) / activeCount 
        : 0.0;

    // Sort
    final sorted = _sortPlaylists(playlists);

    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Library',
                              style: Theme.of(context).textTheme.headlineLarge),
                          Row(
                            children: [
                              // Sort button
                              _SortButton(
                                sortKey: _sortKey,
                                sortOrder: _sortOrder,
                                onTap: () => setState(() =>
                                    _showSortDropdown = !_showSortDropdown),
                              ),
                              const SizedBox(width: 8),
                              // Downloads button
                              GestureDetector(
                                onTap: () => context.push('/downloads'),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(LucideIcons.hardDrive,
                                      size: 18, color: AppColors.textSecondary),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/downloading'),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(LucideIcons.download, size: 18, color: AppColors.textSecondary),
                                ),
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
                    ],
                  ),
                ),

                // ── Import Banners ──
                if (importState.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: importState.values.map((task) {
                        return GlassContainer(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          borderRadius: 12,
                          child: Row(
                            children: [
                              task.status == 'done' 
                                  ? const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 20)
                                  : task.status == 'error'
                                      ? const Icon(LucideIcons.alertCircle, color: Colors.red, size: 20)
                                      : const SizedBox(
                                          width: 16, height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.status == 'done' ? 'Imported ${task.name}' : 'Importing ${task.name}...',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                    if (task.status == 'fetching')
                                      const Text('Fetching playlist...', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))
                                    else if (task.status == 'matching')
                                      Text('Matching songs: ${task.processedSongs} / ${task.totalSongs}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))
                                    else if (task.status == 'saving')
                                      const Text('Saving to library...', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))
                                    else if (task.status == 'done')
                                      const Text('Tap to dismiss', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))
                                    else if (task.status == 'error')
                                      const Text('Failed to import', style: TextStyle(fontSize: 11, color: Colors.redAccent))
                                  ],
                                ),
                              ),
                              if (task.status == 'done' || task.status == 'error')
                                IconButton(
                                  icon: const Icon(LucideIcons.x, size: 16),
                                  onPressed: () => ref.read(importProvider.notifier).dismissTask(task.id),
                                )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // ── Playlist list ──
                Expanded(
                  child: sorted.isEmpty
                      ? _buildEmptyState()
                      : _gridView
                          ? _buildGridView(sorted)
                          : _buildListView(sorted),
                ),
              ],
            ),

            // ── FAB ──
            Positioned(
              bottom: 160, right: 20,
              child: GestureDetector(
                onTap: () => setState(() => _showAddOptions = !_showAddOptions),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [accent, AppColors.computeSecondary(accent)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedRotation(
                        turns: _showAddOptions ? 0.125 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(LucideIcons.plus, size: 20, color: Color(0xFF050505)),
                      ),
                      const SizedBox(width: 6),
                      const Text('Add',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF050505))),
                    ],
                  ),
                ),
              ),
            ),

            // ── Add Options overlay ──
            if (_showAddOptions) _buildAddOptions(accent),

            // ── Import Modal ──
            if (_showImportModal) Positioned.fill(child: _buildImportModal(accent)),

            // ── Create Modal ──
            if (_showCreateModal) Positioned.fill(child: _buildCreateModal(accent)),

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
          ],
        ),
      ),
    );
  }

  List<Playlist> _sortPlaylists(List<Playlist> playlists) {
    final filtered = playlists.where((pl) {
      return pl.songs.isNotEmpty;
    }).toList();

    filtered.sort((a, b) {
      if (_sortKey == 'alpha') {
        final cmp = a.name.compareTo(b.name);
        return _sortOrder == 'desc' ? cmp : -cmp;
      } else {
        final timeA = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final timeB = b.createdAt?.millisecondsSinceEpoch ?? 0;
        final cmp = timeB - timeA;
        return _sortOrder == 'asc' ? cmp : -cmp;
      }
    });
    return filtered;
  }

  void _handleSort(String key) {
    if (_sortKey == key) {
      setState(() => _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc');
    } else {
      setState(() { _sortKey = key; _sortOrder = 'desc'; });
    }
    setState(() => _showSortDropdown = false);
    _savePrefs();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your library is empty.',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Tap "Add" to start your first Pulse.',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildListView(List<Playlist> playlists) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 140),
      itemCount: playlists.length,
      itemBuilder: (context, i) => _PlaylistListTile(
        playlist: playlists[i],
        onTap: () => context.push('/playlist/${playlists[i].id}'),
        onMenu: () => _showPlaylistMenu(playlists[i]),
      ),
    );
  }

  Widget _buildGridView(List<Playlist> playlists) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 0.75,
        crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, i) => _PlaylistGridCard(
        playlist: playlists[i],
        onTap: () => context.push('/playlist/${playlists[i].id}'),
        onMenu: () => _showPlaylistMenu(playlists[i]),
      ),
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
                    if (pl.name == 'Liked Songs') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot rename the Liked Songs playlist.')),
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
                    // Open edit songs modal with buffered copy
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
                    if (pl.name == 'Liked Songs') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot delete the Liked Songs playlist.')),
                      );
                    } else {
                      setState(() { _editingPlaylist = pl; _showDeleteModal = true; });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Icon(LucideIcons.trash2, size: 17, color: AppColors.danger),
                      SizedBox(width: 14),
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
                              Text('Edit Songs',
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
                                    final songMaps = _editSongsList
                                        .map((s) => s.toJson())
                                        .toList();
                                    await ref.read(playlistProvider.notifier).updatePlaylist(
                                      _editSongsPlaylist!.id,
                                      {'songs': songMaps},
                                    );
                                  }
                                  if (mounted) {
                                    setState(() => _showEditSongsModal = false);
                                  }
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
                                          child: const Icon(LucideIcons.x,
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

  Widget _buildAddOptions(Color accent) {
    return GestureDetector(
      onTap: () => setState(() => _showAddOptions = false),
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
                const Text('Add to Library',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Choose how you want to expand your Pulse',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 20),


                _AddOptionItem(
                  iconWidget: Image.asset(
                    'assets/logo.png',
                    width: 20, height: 20,
                    errorBuilder: (_, __, ___) => const Icon(LucideIcons.radioReceiver, size: 20),
                  ),
                  label: 'Import from Pulse',
                  subtitle: 'Paste a Pulse playlist URL',
                  onTap: () {
                    setState(() {
                      _showAddOptions = false;
                      _selectedImportSource = 'pulse';
                      _importUrlController.clear();
                      _showImportModal = true;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _AddOptionItem(
                  iconWidget: Image.asset(
                    'assets/ytmusic.logo.png',
                    width: 20, height: 20,
                    errorBuilder: (_, __, ___) => const Icon(LucideIcons.music2, size: 20),
                  ),
                  label: 'Import from YT Music',
                  subtitle: 'Paste a playlist URL',
                  comingSoon: false,
                  onTap: () {
                    setState(() {
                      _showAddOptions = false;
                      _selectedImportSource = 'ytmusic';
                      _importUrlController.clear();
                      _showImportModal = true;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _AddOptionItem(
                  iconWidget: Image.asset(
                    'assets/spotify.logo.png',
                    width: 20, height: 20,
                    errorBuilder: (_, __, ___) => const Icon(LucideIcons.disc, size: 20, color: Color(0xFF1DB954)),
                  ),
                  label: 'Import from Spotify',
                  subtitle: 'Paste a playlist URL',
                  comingSoon: true,
                  onTap: null,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _showAddOptions = false),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImportModal(Color accent) {
    final isYtm = _selectedImportSource == 'ytmusic';
    final isPulse = _selectedImportSource == 'pulse';
    return GestureDetector(
      onTap: () => setState(() => _showImportModal = false),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // prevent close on card tap
            child: GlassContainer(
              borderRadius: 24, blur: 24,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    isPulse
                        ? 'assets/logo.png'
                        : (isYtm ? 'assets/ytmusic.logo.png' : 'assets/spotify.logo.png'),
                    width: 32, height: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isPulse
                        ? 'Import from Pulse'
                        : (isYtm ? 'Import from YouTube Music' : 'Import from Spotify'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPulse
                        ? 'Paste a Pulse playlist URL'
                        : (isYtm
                            ? 'Paste a YouTube Music playlist or album URL'
                            : 'Paste a Spotify playlist URL'),
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _importUrlController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: isPulse
                          ? 'https://pulse.app/playlist/...'
                          : (isYtm
                              ? 'https://music.youtube.com/playlist?list=...'
                              : 'https://open.spotify.com/playlist/...'),
                      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                        onPressed: () => setState(() => _showImportModal = false),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final url = _importUrlController.text.trim();
                          if (url.isNotEmpty) {
                            setState(() => _showImportModal = false);
                            
                            if (isPulse) {
                              final browseId = _extractBrowseId(url);
                              if (browseId != null) {
                                // Import pulse playlist
                                final newId = await ref.read(playlistProvider.notifier).importPulsePlaylist(browseId);
                                if (newId != null && mounted) {
                                  context.push('/playlist/$newId');
                                } else if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to import Pulse playlist')),
                                  );
                                }
                              }
                            } else {
                              // Spotify or YT Music bulk import
                              ref.read(importProvider.notifier).startImport(url);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Import started in background.')),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: AppColors.background),
                        child: const Text('Import'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _extractBrowseId(String url) {
    // YouTube Music: list=PLAYLIST_ID or browse/PLAYLIST_ID
    final listMatch = RegExp(r'list=([A-Za-z0-9_-]+)').firstMatch(url);
    if (listMatch != null) return listMatch.group(1);
    // Pulse / Spotify: /playlist/ID
    final spotifyMatch = RegExp(r'playlist/([A-Za-z0-9_-]+)').firstMatch(url);
    if (spotifyMatch != null) return spotifyMatch.group(1);
    // Try browse endpoint
    final browseMatch = RegExp(r'browse/([A-Za-z0-9_-]+)').firstMatch(url);
    if (browseMatch != null) return browseMatch.group(1);
    // Fallback — return the whole URL as-is if nothing matched
    return url.isNotEmpty ? url : null;
  }

  Widget _buildCreateModal(Color accent) {
    return GestureDetector(
      onTap: () => setState(() => _showCreateModal = false),
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
                const Text('New Playlist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('What should we call your new playlist?',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                TextField(
                  controller: _createController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'e.g. Midnight Rides',
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
                      onPressed: () => setState(() => _showCreateModal = false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: AppColors.background),
                      onPressed: () {
                        final name = _createController.text.trim();
                        if (name.isNotEmpty) {
                          ref.read(playlistProvider.notifier).createPlaylist(name: name);
                          _createController.clear();
                          setState(() => _showCreateModal = false);
                        }
                      },
                      child: const Text('Create'),
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
                  controller: _renameController, autofocus: true,
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
                        final name = _renameController.text.trim();
                        if (name.isNotEmpty && _editingPlaylist != null) {
                          await ref.read(playlistProvider.notifier)
                              .updatePlaylist(_editingPlaylist!.id, {'name': name});
                          setState(() => _showRenameModal = false);
                        }
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: AppColors.background),
                      onPressed: () async {
                        if (_editingPlaylist != null) {
                          await ref.read(playlistProvider.notifier)
                              .deletePlaylist(_editingPlaylist!.id);
                          setState(() => _showDeleteModal = false);
                        }
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
}

// ── Helper widgets ──

class _SortButton extends StatelessWidget {
  final String sortKey;
  final String sortOrder;
  final VoidCallback onTap;

  const _SortButton({
    required this.sortKey, required this.sortOrder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = sortKey == 'alpha' ? 'A-Z' : 'Recent';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.arrowUpDown, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            Icon(sortOrder == 'asc' ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
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

class _PlaylistListTile extends ConsumerWidget {
  final Playlist playlist;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  const _PlaylistListTile({
    required this.playlist, required this.onTap, required this.onMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioProvider);
    final songs = playlist.songs;
    final thumb = songs.isNotEmpty
        ? ThumbnailUtils.getHighRes(songs.first.thumbnail, size: 200) : '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              // Cover
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 54, height: 54,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: songs.length >= 4
                            ? _QuadCover(songs: songs.take(4).toList())
                            : (thumb.isNotEmpty
                                ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                                : Container(color: AppColors.surface)),
                      ),
                      if (audio.contextPlaylistId == playlist.id)
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
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(playlist.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${songs.length} Songs',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              // More button
              GestureDetector(
                onTap: onMenu,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(LucideIcons.moreVertical, size: 18, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
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
            ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.surface))
            : Container(color: AppColors.surface);
      }).toList(),
    );
  }
}

class _PlaylistGridCard extends ConsumerWidget {
  final Playlist playlist;
  final VoidCallback onTap;
  final VoidCallback onMenu;
  const _PlaylistGridCard({required this.playlist, required this.onTap, required this.onMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioProvider);
    final songs = playlist.songs;
    final thumb = songs.isNotEmpty
        ? ThumbnailUtils.getHighRes(songs.first.thumbnail, size: 300) : '';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: songs.length >= 4
                          ? _QuadCover(songs: songs.take(4).toList())
                          : (thumb.isNotEmpty
                              ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                              : Container(color: AppColors.surface)),
                    ),
                    if (audio.contextPlaylistId == playlist.id)
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
                    Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('${songs.length} Songs',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onMenu,
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
  }
}

class _AddOptionItem extends StatelessWidget {
  final Widget? iconWidget;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;
  final bool comingSoon;

  const _AddOptionItem({
    this.iconWidget, required this.label,
    required this.subtitle, this.onTap,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: comingSoon ? 0.5 : 1.0,
        child: GlassContainer(
          borderRadius: 14,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.surface,
                ),
                child: Center(
                  child: iconWidget ?? const Icon(LucideIcons.plus, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (comingSoon)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
