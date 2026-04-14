import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../data/models/home_section.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/song_action_sheet.dart';

/// Home screen — port of Home.jsx.
/// Shows greeting, recent playlists grid, and horizontal-scrolling song sections.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _musicApi = MusicApi();
  List<HomeSection> _sections = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<void> _loadHome() async {
    setState(() { _loading = true; _error = false; });
    try {
      final sections = await _musicApi.getHome();
      if (mounted) setState(() { _sections = sections; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = true; _loading = false; });
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 18) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final playlistState = ref.watch(playlistProvider);
    final playlists = playlistState.playlists;
    final audio = ref.watch(audioProvider);
    final accent = Theme.of(context).colorScheme.primary;
    final firstName = (auth.displayName ?? 'Member').split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: accent,
          backgroundColor: AppColors.surface,
          onRefresh: _loadHome,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // ── Header ──
              _buildHeader(firstName, accent),
              const SizedBox(height: 24),

              // ── Recent Playlists ──
              if (playlists.isNotEmpty) ...[
                Text('Recent Playlists',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _buildRecentPlaylistsGrid(playlists),
                const SizedBox(height: 24),
              ],

              // ── Music Sections ──
              if (_loading) ...[
                _buildSkeleton(),
                _buildSkeleton(),
                _buildSkeleton(),
              ] else if (_error) ...[
                _buildErrorState(),
              ] else ...[
                for (final section in _sections)
                  _buildSection(section, audio),
              ],

              // Bottom padding for mini player
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(String firstName, Color accent) {
    final secondary = AppColors.computeSecondary(accent);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [accent, secondary],
              ).createShader(bounds),
              child: Text(firstName,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ],
        ),
        // Logo placeholder — accent circle "P"
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [accent, secondary]),
          ),
          child: const Center(
            child: Text('P', style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // ── Recent Playlists Grid (2-col horizontal cards) ──
  Widget _buildRecentPlaylistsGrid(List<dynamic> playlists) {
    final items = playlists.take(6).toList();
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: items.map((pl) {
        final songs = (pl.songs as List<dynamic>?) ?? [];
        final thumb = songs.isNotEmpty
            ? ThumbnailUtils.getHighRes((songs.first as dynamic).thumbnail ?? '', size: 200)
            : '';
        return GestureDetector(
          onTap: () => context.push('/playlist/${pl.id}'),
          child: GlassContainer(
            borderRadius: 12,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 50) / 2,
              height: 56,
              child: Row(
                children: [
                  // Art
                  SizedBox(
                    width: 56, height: 56,
                    child: songs.length >= 4
                        ? _buildQuadArt(songs.take(4).toList())
                        : (thumb.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: thumb, fit: BoxFit.cover,
                                width: 56, height: 56,
                                errorWidget: (_, __, ___) => _artPlaceholder())
                            : _artPlaceholder()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pl.name ?? '',
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuadArt(List<dynamic> songs) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
      child: GridView.count(
        crossAxisCount: 2, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: songs.map((s) {
          final url = ThumbnailUtils.getHighRes(s.thumbnail, size: 120);
          return url.isNotEmpty
              ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _artPlaceholder())
              : _artPlaceholder();
        }).toList(),
      ),
    );
  }

  Widget _artPlaceholder() => Container(color: AppColors.surface);

  // ── Horizontal Song Section ──
  Widget _buildSection(HomeSection section, AudioState audio) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary, letterSpacing: -0.3)),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: section.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final song = section.items[i];
                final isPlaying = audio.currentSong?.videoId == song.videoId;
                return _SongCard(
                  song: song,
                  isPlaying: isPlaying,
                  onTap: () => _handlePlay(song),
                  onLongPress: () => _showMenu(song),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handlePlay(Song song) {
    if (song.isPlayable) {
      ref.read(audioProvider.notifier).playSong(song);
    } else {
      final id = song.playlistId ?? song.browseId ?? song.id;
      if (id.isNotEmpty) context.push('/playlist/$id');
    }
  }

  void _showMenu(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SongActionSheet(song: song),
    );
  }

  // ── Skeleton ──
  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(width: 140, height: 16, borderRadius: 6),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, __) => const SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(width: 130, height: 130, borderRadius: 12),
                    SizedBox(height: 8),
                    SkeletonLoader(width: 104, height: 12, borderRadius: 4),
                    SizedBox(height: 6),
                    SkeletonLoader(width: 72, height: 10, borderRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const Text("Couldn't load music feed.",
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadHome,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.glassBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Retry', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Song Card (horizontal scroll item) ──
class _SongCard extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SongCard({
    required this.song,
    required this.isPlaying,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 400);
    final accent = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Art ──
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    width: 130, height: 130,
                    child: thumb.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumb, fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: AppColors.surface),
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.surface))
                        : Container(color: AppColors.surface),
                  ),
                  // Play overlay
                  if (isPlaying)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black38,
                        child: Center(
                          child: Icon(Icons.equalizer, color: accent, size: 22),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // ── Title ──
            Text(song.title,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: isPlaying ? accent : AppColors.textPrimary)),
            const SizedBox(height: 2),
            // ── Artist ──
            Text(song.artist,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
