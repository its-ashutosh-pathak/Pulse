import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:lucide_icons/lucide_icons.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';

import '../../widgets/spotify_choice_modal.dart';
import '../../data/models/playlist.dart';
import '../../data/models/song.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/import_provider.dart';
import '../../providers/download_provider.dart';
import '../../providers/desktop_layout_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/playing_bars.dart';
import 'downloads_screen.dart';
import 'downloading_screen.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';

/// Library screen — port of Library.jsx.
/// Shows user playlists with sort, grid/list toggle, FAB for create/import.
class PlaylistsScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;
  const PlaylistsScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends ConsumerState<PlaylistsScreen> {
  late int _currentIndex;
  late final PageController _pageController;
  final ScrollController _chipsScrollController = ScrollController();

  String _sortKey = 'recent';
  String _sortOrder = 'desc';
  bool _gridView = false;
  String _dlSortKey = 'recent';
  String _dlSortOrder = 'desc';
  bool _dlGridView = false;
  bool _showSortDropdown = false;
  bool _showAddOptions = false;
  bool _showCreateModal = false;
  bool _showImportModal = false;
  bool _showSpotifyChoiceModal = false;
  String _selectedImportSource = 'ytmusic'; // 'ytmusic' or 'pulse'
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

  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _loadPrefs();

    Connectivity().checkConnectivity().then((result) {
      if (mounted) {
        setState(() => _isOffline = result.isEmpty || !result.any((r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet));
      }
    });

    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() => _isOffline = result.isEmpty || !result.any((r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet));
      }
    });

    if (_currentIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_chipsScrollController.hasClients) {
          double offset = 0;
          if (_currentIndex == 1) {
            offset = 80;
          } else if (_currentIndex == 2) {
            offset = _chipsScrollController.position.maxScrollExtent;
          }
          _chipsScrollController.jumpTo(offset);
        }
      });
    }
  }

  bool _prefsLoaded = false;

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _gridView = prefs.getBool('pulse_lib_view_mode_grid') ?? false;
      _sortKey = prefs.getString('pulse_lib_sort_key') ?? 'recent';
      _sortOrder = prefs.getString('pulse_lib_sort_order') ?? 'desc';
      _dlGridView = prefs.getBool('pulse_dl_view_mode_grid') ?? false;
      _dlSortKey = prefs.getString('pulse_dl_sort_key') ?? 'recent';
      _dlSortOrder = prefs.getString('pulse_dl_sort_order') ?? 'desc';
      _prefsLoaded = true;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pulse_lib_view_mode_grid', _gridView);
    await prefs.setString('pulse_lib_sort_key', _sortKey);
    await prefs.setString('pulse_lib_sort_order', _sortOrder);
    await prefs.setBool('pulse_dl_view_mode_grid', _dlGridView);
    await prefs.setString('pulse_dl_sort_key', _dlSortKey);
    await prefs.setString('pulse_dl_sort_order', _dlSortOrder);
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _createController.dispose();
    _renameController.dispose();
    _importUrlController.dispose();
    _pageController.dispose();
    _chipsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefsLoaded) return const Scaffold(backgroundColor: Colors.transparent);

    ref.listen(importProvider, (previous, current) {
      if (previous == null) return;
      for (final key in current.keys) {
        final currentTask = current[key]!;
        final previousTask = previous[key];
        if (currentTask.status == 'error' && (previousTask == null || previousTask.status != 'error')) {
          ToastUtils.show(context, currentTask.name);
          Future.microtask(() => ref.read(importProvider.notifier).dismissTask(key));
        }
      }
    });

    ref.listen<int>(desktopLibraryTabProvider, (previous, next) {
      if (next != _currentIndex && _pageController.hasClients) {
        _pageController.animateToPage(next, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });

    final playlistState = ref.watch(playlistProvider);
    final importState = ref.watch(importProvider);
    final downloadState = ref.watch(downloadProvider);
    final playlists = playlistState.playlists;
    final accent = Theme.of(context).colorScheme.primary;

    final activeCount = downloadState.activeDownloads.length;
    
    final hasActive = downloadState.activeDownloads.values.any((d) => !d.isPaused);

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(AppLocalizations.of(context)!.libraryTitle,
                                style: Theme.of(context).textTheme.headlineLarge,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          Row(
                            children: [
                              if (_currentIndex == 0 || _currentIndex == 1) ...[
                                // Sort button
                                _SortButton(
                                  sortKey: _currentIndex == 0 ? _sortKey : _dlSortKey,
                                  sortOrder: _currentIndex == 0 ? _sortOrder : _dlSortOrder,
                                  onTap: () => setState(() =>
                                      _showSortDropdown = !_showSortDropdown),
                                ),
                                const SizedBox(width: 8),
                                // View toggle
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_currentIndex == 0) {
                                        _gridView = !_gridView;
                                      } else {
                                        _dlGridView = !_dlGridView;
                                      }
                                    });
                                    _savePrefs();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      (_currentIndex == 0 ? _gridView : _dlGridView) ? LucideIcons.list : LucideIcons.layoutGrid,
                                      size: 18, color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                // Pause / Resume All for Downloading Tab
                                GestureDetector(
                                  onTap: () {
                                    if (hasActive) {
                                      ref.read(downloadProvider.notifier).pauseAll();
                                    } else {
                                      ref.read(downloadProvider.notifier).resumeAll();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.surface,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          hasActive ? Icons.pause : Icons.play_arrow,
                                          size: 16, color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            hasActive ? AppLocalizations.of(context)!.libraryPauseAll : AppLocalizations.of(context)!.libraryResumeAll,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Navigation Chips
                      SingleChildScrollView(
                        controller: _chipsScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Playlists
                            GestureDetector(
                              onTap: () => _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _currentIndex == 0 ? accent.withValues(alpha: 0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.transparent, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.listMusic, size: 16, color: _currentIndex == 0 ? accent : AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Text(AppLocalizations.of(context)!.libraryTabPlaylists, style: TextStyle(fontSize: 14, fontWeight: _currentIndex == 0 ? FontWeight.w600 : FontWeight.w500, color: _currentIndex == 0 ? accent : AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Downloads
                            GestureDetector(
                              onTap: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _currentIndex == 1 ? accent.withValues(alpha: 0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.transparent, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.hardDrive, size: 16, color: _currentIndex == 1 ? accent : AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Text(AppLocalizations.of(context)!.libraryTabDownloads, style: TextStyle(fontSize: 14, fontWeight: _currentIndex == 1 ? FontWeight.w600 : FontWeight.w500, color: _currentIndex == 1 ? accent : AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Downloading
                            GestureDetector(
                              onTap: () => _pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _currentIndex == 2 ? accent.withValues(alpha: 0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.transparent, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.download, size: 16, color: _currentIndex == 2 ? accent : AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Text(AppLocalizations.of(context)!.libraryTabDownloading, style: TextStyle(fontSize: 14, fontWeight: _currentIndex == 2 ? FontWeight.w600 : FontWeight.w500, color: _currentIndex == 2 ? accent : AppColors.textSecondary)),
                                    if (activeCount > 0) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$activeCount',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        final progress = task.totalSongs > 0
                            ? task.processedSongs / task.totalSongs
                            : 0.0;
                        final isActive = task.status == 'fetching' || task.status == 'matching' || task.status == 'saving';

                        return GlassContainer(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          borderRadius: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Status icon
                                  if (task.status == 'done')
                                    const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 20)
                                  else if (task.status == 'error')
                                    const Icon(LucideIcons.alertCircle, color: Colors.redAccent, size: 20)
                                  else if (task.status == 'queued')
                                    const Icon(LucideIcons.clock, color: Colors.orange, size: 20)
                                  else
                                    SizedBox(
                                      width: 18, height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: accent),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Text(
                                          task.status == 'done'
                                              ? AppLocalizations.of(context)!.libraryImportedTask(task.name)
                                              : task.name,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        // Subtitle
                                        Text(
                                          task.status == 'queued'
                                              ? AppLocalizations.of(context)!.libraryImportWaiting
                                              : task.status == 'fetching'
                                                  ? AppLocalizations.of(context)!.libraryImportFetching
                                                  : task.status == 'matching'
                                                      ? AppLocalizations.of(context)!.libraryImportProcessed(task.processedSongs.toString(), task.totalSongs.toString(), task.matchedSongs.toString())
                                                      : task.status == 'saving'
                                                          ? AppLocalizations.of(context)!.libraryImportSaving
                                                          : task.status == 'done'
                                                              ? (task.matchedSongs > 0 ? AppLocalizations.of(context)!.libraryImportDoneSongs(task.matchedSongs.toString()) : AppLocalizations.of(context)!.libraryImportDoneAll)
                                                              : task.status == 'error'
                                                                  ? task.name
                                                                  : '',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: task.status == 'error' ? Colors.redAccent : AppColors.textSecondary,
                                          ),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (task.status == 'done' || task.status == 'error')
                                    IconButton(
                                      icon: const Icon(LucideIcons.x, size: 16),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => ref.read(importProvider.notifier).dismissTask(task.id),
                                    ),
                                ],
                              ),
                              // Progress bar
                              if (isActive && task.totalSongs > 0) ...[
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 3,
                                    backgroundColor: Colors.white12,
                                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // ── Tab Content ──
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
                      if (!isDesktop && _isOffline && index != 1) {
                        if (index == 0) context.go('/library');
                        if (index == 2) context.go('/downloading');
                        return;
                      }
                      setState(() {
                        _currentIndex = index;
                        _showSortDropdown = false;
                      });
                      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
                        Future.microtask(() => ref.read(desktopLibraryTabProvider.notifier).state = index);
                      }
                      if (_chipsScrollController.hasClients) {
                        double offset = 0;
                        if (index == 1) {
                          offset = 80;
                        } else if (index == 2) {
                          offset = _chipsScrollController.position.maxScrollExtent;
                        }
                        _chipsScrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }
                    },
                    children: [
                      // Page 0: Playlists
                      sorted.isEmpty
                          ? _buildEmptyState()
                          : _gridView
                              ? _buildGridView(sorted)
                              : _buildListView(sorted),
                      // Page 1: Downloads
                      DownloadsScreen(
                        sortKey: _dlSortKey,
                        sortOrder: _dlSortOrder,
                        gridView: _dlGridView,
                      ),
                      // Page 2: Downloading
                      const DownloadingScreen(),
                    ],
                  ),
                ),
              ],
            ),

            // ── FAB ──
            if (_currentIndex == 0)
              Positioned(
                bottom: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? 24 : 160, right: 20,
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
                      Text(AppLocalizations.of(context)!.libraryAddButton,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF050505))),
                    ],
                  ),
                ),
              ),
            ),

            // ── Add Options overlay ──
            if (_showAddOptions) _buildAddOptions(accent),

            // ── Import Modal ──
            if (_showImportModal) Positioned.fill(child: _buildImportModal(accent)),

            // ── Spotify Choice Modal ──
            if (_showSpotifyChoiceModal) 
              Positioned.fill(
                child: SpotifyChoiceModal(
                  onClose: () => setState(() => _showSpotifyChoiceModal = false),
                  onSelectEmbed: () {
                    setState(() {
                      _showSpotifyChoiceModal = false;
                      _selectedImportSource = 'spotify';
                      _importUrlController.clear();
                      _showImportModal = true;
                    });
                  },
                  onSelectByoa: () {
                    setState(() => _showSpotifyChoiceModal = false);
                    context.push('/import');
                  },
                ),
              ),

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
                          label: AppLocalizations.of(context)!.librarySortRecent, isActive: (_currentIndex == 0 ? _sortKey : _dlSortKey) == 'recent',
                          sortOrder: _currentIndex == 0 ? _sortOrder : _dlSortOrder,
                          onTap: () => _handleSort('recent'),
                        ),
                        _SortOption(
                          label: AppLocalizations.of(context)!.librarySortAlpha, isActive: (_currentIndex == 0 ? _sortKey : _dlSortKey) == 'alpha',
                          sortOrder: _currentIndex == 0 ? _sortOrder : _dlSortOrder,
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
    if (_currentIndex == 0) {
      if (_sortKey == key) {
        setState(() => _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc');
      } else {
        setState(() { _sortKey = key; _sortOrder = 'desc'; });
      }
    } else {
      if (_dlSortKey == key) {
        setState(() => _dlSortOrder = _dlSortOrder == 'asc' ? 'desc' : 'asc');
      } else {
        setState(() { _dlSortKey = key; _dlSortOrder = 'desc'; });
      }
    }
    setState(() => _showSortDropdown = false);
    _savePrefs();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.libraryEmptyTitle,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context)!.libraryEmptyDesc,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildListView(List<Playlist> playlists) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 180),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 180),
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
                    if (pl.name == 'Liked Songs') {
                      ToastUtils.show(context, AppLocalizations.of(context)!.libraryRenameLikedError);
                    } else {
                      _renameController.text = pl.name;
                      setState(() { _editingPlaylist = pl; _showRenameModal = true; });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      const Icon(LucideIcons.edit2, size: 17), const SizedBox(width: 14),
                      Flexible(child: Text(AppLocalizations.of(context)!.libraryRename, style: const TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _editSongsPlaylist = pl;
                      _editSongsList = List<Song>.from(pl.songs);
                      _showEditSongsModal = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      const Icon(LucideIcons.listMusic, size: 17), const SizedBox(width: 14),
                      Flexible(child: Text(AppLocalizations.of(context)!.libraryEditSongs, style: const TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    if (pl.name == 'Liked Songs') {
                      ToastUtils.show(context, AppLocalizations.of(context)!.libraryDeleteLikedError);
                    } else {
                      setState(() { _editingPlaylist = pl; _showDeleteModal = true; });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      const Icon(LucideIcons.trash2, size: 17, color: AppColors.danger),
                      const SizedBox(width: 14),
                      Flexible(child: Text(AppLocalizations.of(context)!.libraryDelete, style: const TextStyle(fontSize: 15, color: AppColors.danger), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.libraryEditSongsTitle,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(
                                  _editSongsList.length == 1 
                                      ? AppLocalizations.of(context)!.libraryEditSongsCountSingle('1')
                                      : AppLocalizations.of(context)!.libraryEditSongsCountPlural(_editSongsList.length.toString()),
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => setState(() => _showEditSongsModal = false),
                                child: Text(AppLocalizations.of(context)!.libraryCancel),
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
                                child: Text(AppLocalizations.of(context)!.librarySave),
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
                              child: Text(AppLocalizations.of(context)!.libraryNoSongs,
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
                Text(AppLocalizations.of(context)!.libraryAddOptionsTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)!.libraryAddOptionsDesc,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 20),


                _AddOptionItem(
                  iconWidget: Image.asset(
                    'assets/logo.png',
                    width: 20, height: 20,
                    errorBuilder: (_, __, ___) => const Icon(LucideIcons.radioReceiver, size: 20),
                  ),
                  label: AppLocalizations.of(context)!.libraryImportPulse,
                  subtitle: AppLocalizations.of(context)!.libraryImportPulseDesc,
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
                  label: AppLocalizations.of(context)!.libraryImportYtm,
                  subtitle: AppLocalizations.of(context)!.libraryImportYtmDesc,
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
                  label: AppLocalizations.of(context)!.libraryImportSpotify,
                  subtitle: AppLocalizations.of(context)!.libraryImportSpotifyDesc,
                  comingSoon: false,
                  onTap: () {
                    setState(() {
                      _showAddOptions = false;
                      _showSpotifyChoiceModal = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _showAddOptions = false),
                  child: Text(AppLocalizations.of(context)!.libraryClose),
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
                        ? AppLocalizations.of(context)!.libraryImportPulse
                        : isYtm
                            ? AppLocalizations.of(context)!.libraryImportYtmFull
                            : AppLocalizations.of(context)!.libraryImportSpotifyFull,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPulse
                        ? AppLocalizations.of(context)!.libraryImportPulseDesc
                        : isYtm
                            ? AppLocalizations.of(context)!.libraryImportYtmUrlDesc
                            : AppLocalizations.of(context)!.libraryImportSpotifyUrlDesc,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _importUrlController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: isPulse
                          ? AppLocalizations.of(context)!.libraryImportPulseHint
                          : isYtm
                              ? AppLocalizations.of(context)!.libraryImportYtmHint
                              : AppLocalizations.of(context)!.libraryImportSpotifyHint,
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
                        child: Text(AppLocalizations.of(context)!.libraryCancel),
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
                                  ToastUtils.show(context, AppLocalizations.of(context)!.libraryImportFailed);
                                }
                              }
                            } else {
                              // Spotify or YT Music bulk import
                              ref.read(importProvider.notifier).startImport(url);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: AppColors.background),
                        child: Text(AppLocalizations.of(context)!.libraryImportBtn),
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
                Text(AppLocalizations.of(context)!.libraryCreateTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.libraryCreateDesc,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                TextField(
                  controller: _createController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.libraryCreateHint,
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
                      child: Text(AppLocalizations.of(context)!.libraryCancel),
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
                      child: Text(AppLocalizations.of(context)!.libraryCreateBtn),
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
                Text(AppLocalizations.of(context)!.libraryRenameTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.libraryRenameDesc,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                      child: Text(AppLocalizations.of(context)!.libraryCancel),
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
                      child: Text(AppLocalizations.of(context)!.libraryRenameBtn),
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
                Text(AppLocalizations.of(context)!.libraryDeleteTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.libraryDeleteDesc(_editingPlaylist?.name ?? ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _showDeleteModal = false),
                      child: Text(AppLocalizations.of(context)!.libraryCancel),
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
                      child: Text(AppLocalizations.of(context)!.libraryDeleteBtn),
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
    final label = sortKey == 'alpha' ? AppLocalizations.of(context)!.librarySortLabelAlpha : AppLocalizations.of(context)!.librarySortLabelRecent;
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160),
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
              Flexible(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 4),
              Icon(sortOrder == 'asc' ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                  size: 14, color: AppColors.textSecondary),
            ],
          ),
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
            Flexible(
              child: Text(label, style: TextStyle(
                  fontSize: 14, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Theme.of(context).colorScheme.primary : AppColors.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
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
                    Text(AppLocalizations.of(context)!.librarySongsCount(songs.length.toString()),
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
                    Text(AppLocalizations.of(context)!.librarySongsCount(songs.length.toString()),
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
                    AppLocalizations.of(context)!.libraryComingSoon,
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
