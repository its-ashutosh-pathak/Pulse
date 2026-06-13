import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/models/song.dart';
import '../../data/models/home_section.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/stats_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/song_action_sheet.dart';
import '../../widgets/playing_bars.dart';

/// Home screen — port of Home.jsx.
/// Shows greeting, recent playlists grid, and horizontal-scrolling song sections.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).loadHome();
      ref.read(statsProvider.notifier).loadStats('week');
    });
  }

  Future<void> _loadHome() async {
    await ref.read(homeProvider.notifier).loadHome(forceRefresh: true);
    await ref.read(statsProvider.notifier).loadStats('week', force: true);
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
    final homeState = ref.watch(homeProvider);
    final accent = Theme.of(context).colorScheme.primary;
    final firstName = (auth.displayName ?? 'Member').split(' ').first;
    
    final stats = ref.watch(statsProvider);
    final speedDialSongs = stats.topSongs.map((s) => Song.fromJson(s)).toList();
    final recentlyPlayedSongs = stats.recentSongs.map((s) => Song.fromJson(s)).toList();

    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false,
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
              if (playlists.where((p) => ((p.songs as List<dynamic>?) ?? []).isNotEmpty).isNotEmpty) ...[
                Text('Recent Playlists',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _buildRecentPlaylistsGrid(playlists, audio),
              ],
              const SizedBox(height: 12),

              // ── Recently Played ──
              if (recentlyPlayedSongs.isNotEmpty) ...[
                _buildSection(
                  HomeSection(title: 'Recently played', items: recentlyPlayedSongs),
                  audio,
                ),
              ],

              // ── Speed dial ──
              if (speedDialSongs.isNotEmpty) ...[
                _buildSection(
                  HomeSection(title: 'Speed dial', items: speedDialSongs.take(15).toList()),
                  audio,
                ),
              ],

              // ── Music Sections ──
              if (homeState.loading && homeState.sections.isEmpty) ...[
                _buildSkeleton(),
                _buildSkeleton(),
                _buildSkeleton(),
              ] else if (homeState.error && homeState.sections.isEmpty) ...[
                _buildErrorState(),
              ] else if (homeState.sections.isEmpty) ...[
                _buildEmptyState(),
              ] else ...[
                for (final section in homeState.sections)
                  if (section.items.isNotEmpty)
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
        // Logo
        Image.asset('assets/logo.png', width: 44, height: 44),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(LucideIcons.radio, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text('No content available',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadHome,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Playlists Grid (2-col horizontal cards) ──
  Widget _buildRecentPlaylistsGrid(List<dynamic> playlists, AudioState audio) {
    final items = playlists.where((pl) {
      final songs = (pl.songs as List<dynamic>?) ?? [];
      return songs.isNotEmpty;
    }).take(6).toList();
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 56, // Match exact height
      ),
      itemBuilder: (context, i) {
        final pl = items[i];
        final songs = (pl.songs as List<dynamic>?) ?? [];
        final thumb = songs.isNotEmpty
            ? ThumbnailUtils.getHighRes((songs.first as dynamic).thumbnail ?? '', size: 200)
            : '';
        return GestureDetector(
          onTap: () => context.push('/playlist/${pl.id}'),
          child: GlassContainer(
            borderRadius: 12,
            child: Row(
              children: [
                  // Art
                  SizedBox(
                    width: 56, height: 56,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: songs.length >= 4
                              ? _buildQuadArt(songs.take(4).toList())
                              : (thumb.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: thumb, fit: BoxFit.cover,
                                      width: 56, height: 56,
                                      errorWidget: (_, __, ___) => _artPlaceholder())
                                  : _artPlaceholder()),
                        ),
                        if (audio.contextPlaylistId == pl.id)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: Center(
                                child: PlayingBars(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 18,
                                  isPaused: !audio.isPlaying,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
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
        );
      },
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
  Widget _buildSection(HomeSection section, AudioState audio, {bool hasChevron = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary, letterSpacing: -0.3)),
              if (hasChevron)
                const Icon(LucideIcons.chevronRight, size: 20, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: section.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final song = section.items[i];
                final isPlaying = song.isPlayable
                    ? audio.currentSong?.videoId == song.videoId
                    : audio.contextPlaylistId == (song.playlistId ?? song.browseId ?? song.id);
                return _SongCard(
                  song: song,
                  isPlaying: isPlaying,
                  isPaused: !audio.isPlaying,
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
      ref.read(audioProvider.notifier).playSong(song, clearQueue: true);
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
  final bool isPaused;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SongCard({
    required this.song,
    required this.isPlaying,
    required this.isPaused,
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
                          child: PlayingBars(color: accent, height: 22, isPaused: isPaused),
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
