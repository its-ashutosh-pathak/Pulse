import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../providers/playlist_provider.dart';
import '../../widgets/glass_container.dart';

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
  final _createController = TextEditingController();

  // For rename/delete modals
  dynamic _editingPlaylist;
  bool _showRenameModal = false;
  bool _showDeleteModal = false;
  final _renameController = TextEditingController();

  @override
  void dispose() {
    _createController.dispose();
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistProvider);
    final playlists = playlistState.playlists;
    final accent = Theme.of(context).colorScheme.primary;

    // Sort
    final sorted = _sortPlaylists(playlists);

    return Scaffold(
      body: SafeArea(
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
                                  child: const Icon(LucideIcons.download,
                                      size: 18, color: AppColors.textSecondary),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // View toggle
                              GestureDetector(
                                onTap: () => setState(() => _gridView = !_gridView),
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

                      // Sort dropdown
                      if (_showSortDropdown)
                        GlassContainer(
                          borderRadius: 12,
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              _SortOption(
                                label: 'Recent', isActive: _sortKey == 'recent',
                                sortOrder: _sortOrder,
                                onTap: () => _handleSort('recent'),
                              ),
                              _SortOption(
                                label: 'A-Z', isActive: _sortKey == 'alpha',
                                sortOrder: _sortOrder,
                                onTap: () => _handleSort('alpha'),
                              ),
                            ],
                          ),
                        ),
                    ],
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
              bottom: 100, right: 20,
              child: GestureDetector(
                onTap: () => setState(() => _showAddOptions = !_showAddOptions),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [accent, AppColors.computeSecondary(accent)]),
                    borderRadius: BorderRadius.circular(50),
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

            // ── Create Modal ──
            if (_showCreateModal) _buildCreateModal(accent),

            // ── Rename Modal ──
            if (_showRenameModal) _buildRenameModal(accent),

            // ── Delete Modal ──
            if (_showDeleteModal) _buildDeleteModal(accent),
          ],
        ),
      ),
    );
  }

  List<dynamic> _sortPlaylists(List<dynamic> playlists) {
    final filtered = playlists.where((pl) {
      final songs = pl.songs as List<dynamic>? ?? [];
      return songs.isNotEmpty;
    }).toList();

    filtered.sort((a, b) {
      if (_sortKey == 'alpha') {
        final cmp = (a.name ?? '').compareTo(b.name ?? '');
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

  Widget _buildListView(List<dynamic> playlists) {
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

  Widget _buildGridView(List<dynamic> playlists) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.85,
        crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, i) => _PlaylistGridCard(
        playlist: playlists[i],
        onTap: () => context.push('/playlist/${playlists[i].id}'),
      ),
    );
  }

  void _showPlaylistMenu(dynamic pl) {
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
                    _renameController.text = pl.name ?? '';
                    setState(() { _editingPlaylist = pl; _showRenameModal = true; });
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
                    setState(() { _editingPlaylist = pl; _showDeleteModal = true; });
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
                  icon: LucideIcons.plus, label: 'Create Playlist',
                  subtitle: 'Start from scratch',
                  onTap: () {
                    setState(() { _showAddOptions = false; _showCreateModal = true; });
                  },
                ),
                const SizedBox(height: 10),
                _AddOptionItem(
                  icon: LucideIcons.music2, label: 'Import from YT Music',
                  subtitle: 'Sync your existing library',
                  onTap: () {
                    setState(() => _showAddOptions = false);
                    context.push('/import');
                  },
                ),
                const SizedBox(height: 10),
                _AddOptionItem(
                  icon: LucideIcons.disc, label: 'Import from Spotify',
                  subtitle: 'Migrate your playlists',
                  onTap: () {
                    setState(() => _showAddOptions = false);
                    context.push('/import');
                  },
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
                const Text('Rename Pulse',
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
                      onPressed: () async {
                        final name = _renameController.text.trim();
                        if (name.isNotEmpty && _editingPlaylist != null) {
                          await ref.read(playlistProvider.notifier)
                              .updatePlaylist(_editingPlaylist.id, {'name': name});
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
                const Text('Delete Pulse?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete "${_editingPlaylist?.name}"? This pulse will be lost forever.',
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
                          backgroundColor: AppColors.danger),
                      onPressed: () async {
                        if (_editingPlaylist != null) {
                          await ref.read(playlistProvider.notifier)
                              .deletePlaylist(_editingPlaylist.id);
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.arrowUpDown, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Icon(sortOrder == 'asc' ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                size: 12, color: AppColors.textSecondary),
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

class _PlaylistListTile extends StatelessWidget {
  final dynamic playlist;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  const _PlaylistListTile({
    required this.playlist, required this.onTap, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    final songs = playlist.songs as List<dynamic>? ?? [];
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
                  child: songs.length >= 4
                      ? _QuadCover(songs: songs.take(4).toList())
                      : (thumb.isNotEmpty
                          ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                          : Container(color: AppColors.surface)),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(playlist.name ?? '',
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
  final List<dynamic> songs;
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

class _PlaylistGridCard extends StatelessWidget {
  final dynamic playlist;
  final VoidCallback onTap;
  const _PlaylistGridCard({required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final songs = playlist.songs as List<dynamic>? ?? [];
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
                child: thumb.isNotEmpty
                    ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(color: AppColors.surface))
                    : Container(color: AppColors.surface),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(playlist.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text('${songs.length} Songs',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _AddOptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _AddOptionItem({
    required this.icon, required this.label,
    required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
