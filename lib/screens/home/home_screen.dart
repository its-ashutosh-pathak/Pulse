import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/models/song.dart';
import '../../data/models/home_section.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/desktop_layout_provider.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/song_action_sheet.dart';
import '../../widgets/playing_bars.dart';
import '../../services/ytmusic_api.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import '../artist/artist_screen.dart';
import '../../data/models/artist.dart';
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
      ref.read(statsProvider.notifier).loadStats('week').then((_) {
        // Once stats are loaded, seed quick picks from the user's top 3 most recent songs
        final recentSongs = ref.read(statsProvider).recentSongs;
        if (recentSongs.isNotEmpty) {
          final seeds = recentSongs.map((s) => Song.fromJson(s)).toList();
          ref.read(quickPicksProvider.notifier).loadForRecentSongs(seeds);
          ref.read(favoriteArtistProvider.notifier).loadForRecentSongs(seeds);
        }
      });
    });
  }

  Future<void> _loadHome() async {
    await ref.read(homeProvider.notifier).loadHome(forceRefresh: true);
    await ref.read(statsProvider.notifier).loadStats('week', force: true);
    // Re-seed quick picks on manual refresh
    final recentSongs = ref.read(statsProvider).recentSongs;
    if (recentSongs.isNotEmpty) {
      final seeds = recentSongs.map((s) => Song.fromJson(s)).toList();
      ref.read(quickPicksProvider.notifier).loadForRecentSongs(seeds);
      ref.read(favoriteArtistProvider.notifier).loadForRecentSongs(seeds);
    }
  }

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppLocalizations.of(context)!.homeGreetingMorning;
    if (hour < 18) return AppLocalizations.of(context)!.homeGreetingAfternoon;
    return AppLocalizations.of(context)!.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final playlistState = ref.watch(playlistProvider);
    final playlists = playlistState.playlists;
    final audio = ref.watch(audioProvider.select((state) => AudioState(
          currentSong: state.currentSong,
          isPlaying: state.isPlaying,
          contextPlaylistId: state.contextPlaylistId,
          isShuffled: state.isShuffled,
          repeatMode: state.repeatMode,
          isLoading: state.isLoading,
        )));
    final homeState = ref.watch(homeProvider);
    final accent = Theme.of(context).colorScheme.primary;
    final firstName =
        (auth.displayName ?? AppLocalizations.of(context)!.homeMember)
            .split(' ')
            .first;

    final stats = ref.watch(statsProvider);
    final speedDialSongs = stats.topSongs.map((s) => Song.fromJson(s)).toList();
    final recentlyPlayedSongs = stats.recentSongs
        .map((s) => Song.fromJson(s))
        .toList();
    final quickPicks = ref.watch(quickPicksProvider);
    final favArtist = ref.watch(favoriteArtistProvider);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: accent,
          backgroundColor: AppColors.surface,
          onRefresh: _loadHome,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // ── Header ──
              _buildHeader(firstName, accent, auth.user?.uid, auth.isAdmin),
              const SizedBox(height: 24),

              // ── Recent Playlists ──
              if (playlists
                  .where((p) => ((p.songs as List<dynamic>?) ?? []).isNotEmpty)
                  .isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.homeRecentPlaylists,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _buildRecentPlaylistsGrid(playlists, audio),
              ],
              const SizedBox(height: 12),

              // ── Recently Played ──
              if (recentlyPlayedSongs.isNotEmpty) ...[
                _buildSection(
                  HomeSection(
                    title: AppLocalizations.of(context)!.homeRecentlyPlayed,
                    items: recentlyPlayedSongs,
                  ),
                  audio,
                ),
              ],

              // ── Speed dial ──
              if (speedDialSongs.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    AppLocalizations.of(context)!.homeSpeedDial,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SpeedDialSection(
                  songs: speedDialSongs.take(18).toList(),
                  audio: audio,
                  onPlay: _handlePlay,
                  onMenu: _showMenu,
                ),
              ],

              // ── Quick Picks (personalised — seeded from user's recently played songs) ──
              if (quickPicks.groups.isNotEmpty) ...[
                _QuickPicksSection(
                  groups: quickPicks.groups,
                  audio: audio,
                  onPlay: _handlePlay,
                  onMenu: _showMenu,
                  onLoadPage: (page) => ref.read(quickPicksProvider.notifier).fetchGroup(page),
                ),
              ],

              // ── Favorite Artist ──
              if (favArtist.groups.isNotEmpty) ...[
                _FavoriteArtistSection(
                  groups: favArtist.groups,
                  audio: audio,
                  onPlay: _handlePlay,
                  onMenu: _showMenu,
                  onPlayAll: (playlistId, songs) async {
                    if (songs.isEmpty) return;
                    final notifier = ref.read(audioProvider.notifier);
                    if (playlistId != null && playlistId.isNotEmpty) {
                      notifier.playSong(songs.first, contextPlaylistId: playlistId, clearQueue: true, isManual: true);
                      try {
                        final pl = await YtMusicApi().getPlaylist(playlistId);
                        if (pl.songs.isNotEmpty) {
                          final fullSongs = pl.songs;
                          if (fullSongs.first.videoId == songs.first.videoId) {
                            notifier.replaceQueue(fullSongs.skip(1).toList());
                          } else {
                            notifier.replaceQueue(fullSongs);
                          }
                        }
                      } catch (_) {}
                    } else {
                      notifier.playSong(songs.first, clearQueue: true, isManual: true);
                      notifier.replaceQueue(songs.skip(1).toList());
                    }
                  },
                  onLoadPage: (index) => ref.read(favoriteArtistProvider.notifier).fetchGroup(index),
                ),
              ],

              // ── Music Sections (all YT Music home sections) ──
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
                  if (section.items.isNotEmpty) _buildSection(section, audio),
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
  Widget _buildHeader(
    String firstName,
    Color accent,
    String? userId,
    bool isAdmin,
  ) {
    final secondary = AppColors.computeSecondary(accent);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [accent, secondary],
                ).createShader(bounds),
                child: Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (kIsWeb ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux)
          _buildBellIcon(userId, isAdmin, accent)
        else
          // Logo
          Image.asset('assets/logo.png', width: 44, height: 44),
      ],
    );
  }

  Widget _buildBellIcon(String? userId, bool isAdmin, Color accent) {
    return Transform.translate(
      offset: const Offset(12, -12),
      child: IconButton(
        icon: Stack(
          children: [
            Icon(LucideIcons.bell, size: 24, color: accent),
            if (userId != null)
              if (isAdmin)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('support_channels')
                      .where('unreadByAdmin', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.docs.length ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('support_messages')
                      .where(
                        Filter.or(
                          Filter('userId', isEqualTo: userId),
                          Filter('isAnnouncement', isEqualTo: true),
                        ),
                      )
                      // Only fetch messages newer than the last time user opened chat.
                      // Defaults to 7 days ago for new users. This replaces streaming
                      // ALL messages ever — now only a handful of docs are watched.
                      .where(
                        'timestamp',
                        isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(
                          ref.watch(unreadBadgeTimeProvider) > 0
                              ? ref.watch(unreadBadgeTimeProvider)
                              : DateTime.now()
                                  .subtract(const Duration(days: 7))
                                  .millisecondsSinceEpoch,
                        ),
                      )
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
                    int count = 0;
                    for (var doc in docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final isMe = data['senderId'] == userId;
                      if (!isMe) count++;
                    }
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final now =
              DateTime.now().millisecondsSinceEpoch + 60000; // +1 min buffer
          await prefs.setInt('lastOpenedSupportTime', now);
          if (mounted) {
            ref.read(unreadBadgeTimeProvider.notifier).state = now;
            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
              ref.read(desktopRightPaneProvider.notifier).state =
                  DesktopRightPane.communication;
            } else {
              context.push('/communication');
            }
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(
              LucideIcons.radio,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.homeNoContent,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadHome,
              child: Text(AppLocalizations.of(context)!.homeRefresh),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Playlists Grid (2-col horizontal cards) ──
  Widget _buildRecentPlaylistsGrid(List<dynamic> playlists, AudioState audio) {
    final items = playlists
        .where((pl) {
          final songs = (pl.songs as List<dynamic>?) ?? [];
          return songs.isNotEmpty;
        })
        .take(6)
        .toList();
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 64,
      ),
      itemBuilder: (context, i) {
        final pl = items[i];
        final songs = (pl.songs as List<dynamic>?) ?? [];
        final thumb = songs.isNotEmpty
            ? ThumbnailUtils.getHighRes(
                (songs.first as dynamic).thumbnail ?? '',
                size: 200,
              )
            : '';
        return GestureDetector(
          onTap: () => context.push('/playlist/${pl.id}'),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surface, width: 1.5),
            ),
            child: Row(
              children: [
                // Art
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: songs.length >= 4
                                ? _buildQuadArt(songs.take(4).toList())
                                : (thumb.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: thumb,
                                          fit: BoxFit.cover,
                                          width: 56,
                                          height: 56,
                                        errorWidget: (_, __, ___) =>
                                            _artPlaceholder(),
                                      )
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
                ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    pl.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
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
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: songs.map((s) {
        final url = ThumbnailUtils.getHighRes(s.thumbnail, size: 120);
        return url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _artPlaceholder(),
              )
            : _artPlaceholder();
      }).toList(),
    );
  }

  Widget _artPlaceholder() => Container(color: AppColors.surface);



  Widget _buildSection(
    HomeSection section,
    AudioState audio, {
    bool hasChevron = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasChevron)
                const Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
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
                    : audio.contextPlaylistId ==
                          (song.playlistId ?? song.browseId ?? song.id);
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
      ref
          .read(audioProvider.notifier)
          .playSong(song, clearQueue: true, isManual: true);
    } else {
      final id = song.playlistId ?? song.browseId ?? song.id;
      if (id.isNotEmpty) context.push('/playlist/$id');
    }
  }

  void _showMenu(Song song) {
    showModalBottomSheet(
      useRootNavigator: true,
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
            Text(
              AppLocalizations.of(context)!.homeLoadError,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadHome,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.glassBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.homeRetry,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Speed Dial Section Widget ──
class _SpeedDialSection extends StatefulWidget {
  final List<Song> songs;
  final AudioState audio;
  final void Function(Song) onPlay;
  final void Function(Song) onMenu;

  const _SpeedDialSection({
    required this.songs,
    required this.audio,
    required this.onPlay,
    required this.onMenu,
  });

  @override
  State<_SpeedDialSection> createState() => _SpeedDialSectionState();
}

class _SpeedDialSectionState extends State<_SpeedDialSection> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      final p = _controller.page?.round() ?? 0;
      if (p != _currentPage) {
        setState(() => _currentPage = p);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int perPage = 6;
    final pageCount = (widget.songs.length / perPage).ceil();

    return Column(
      children: [
        SizedBox(
          height: (MediaQuery.of(context).size.width - 40) / 3 * 2 + 12,
          child: PageView.builder(
            controller: _controller,
            itemCount: pageCount,
            itemBuilder: (context, page) {
              final start = page * perPage;
              final end = (start + perPage).clamp(0, widget.songs.length);
              final pageSongs = widget.songs.sublist(start, end);
              return Padding(
                padding: EdgeInsets.only(
                  left: page > 0 ? 8 : 0,
                  right: page < pageCount - 1 ? 8 : 0,
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: pageSongs.length,
                  itemBuilder: (context, i) {
                    final song = pageSongs[i];
                    final isPlaying = widget.audio.currentSong?.videoId == song.videoId;
                    return _SpeedDialCard(
                      song: song,
                      isPlaying: isPlaying,
                      isPaused: !widget.audio.isPlaying,
                      onTap: () => widget.onPlay(song),
                      onLongPress: () => widget.onMenu(song),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (pageCount > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageCount, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Quick Picks Section Widget ──
class _QuickPicksSection extends StatefulWidget {
  final List<QuickPickGroup> groups;
  final AudioState audio;
  final void Function(Song) onPlay;
  final void Function(Song) onMenu;
  final void Function(int) onLoadPage;

  const _QuickPicksSection({
    required this.groups,
    required this.audio,
    required this.onPlay,
    required this.onMenu,
    required this.onLoadPage,
  });

  @override
  State<_QuickPicksSection> createState() => _QuickPicksSectionState();
}

class _QuickPicksSectionState extends State<_QuickPicksSection> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      final p = _controller.page?.round() ?? 0;
      if (p != _currentPage) {
        setState(() => _currentPage = p);
        widget.onLoadPage(p);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty) return const SizedBox.shrink();

    final pageCount = widget.groups.length;
    final currentGroup = widget.groups[_currentPage];
    const itemHeight = 74.0;
    const int perPage = 5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Because you listen to “${currentGroup.seedTitle}”',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: perPage * itemHeight,
            child: PageView.builder(
              controller: _controller,
              itemCount: pageCount,
              itemBuilder: (context, page) {
                final group = widget.groups[page];
                
                if (group.songs == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                
                if (group.hasError || group.songs!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recommendations found',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  );
                }

                final groupSongs = group.songs!;
                return Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: groupSongs.map((song) {
                      final isPlaying = widget.audio.currentSong?.videoId == song.videoId;
                      return _QuickPickItem(
                        song: song,
                        isPlaying: isPlaying,
                        isPaused: !widget.audio.isPlaying,
                        onTap: () => widget.onPlay(song),
                        onLongPress: () => widget.onMenu(song),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          if (pageCount > 1) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pageCount, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Quick Pick Item (list row: thumbnail + title + artist, no three-dot) ──
class _QuickPickItem extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _QuickPickItem({
    required this.song,
    required this.isPlaying,
    required this.isPaused,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 200);
    final accent = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surface, width: 1.5),
        ),
        child: Row(
          children: [
            // Thumbnail
            Padding(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: thumb.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: thumb,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(color: AppColors.surface),
                                errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                              )
                            : Container(color: AppColors.surface),
                      ),
                      if (isPlaying)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black45,
                            child: Center(
                              child: PlayingBars(color: accent, height: 16, isPaused: isPaused),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Title + Artist
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? accent : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// ── Speed Dial Card (full-bleed art + title overlay) ──
class _SpeedDialCard extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SpeedDialCard({
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed thumbnail
            thumb.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: thumb,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.surface),
                    errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                  )
                : Container(color: AppColors.surface),

            // Gradient overlay for title readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
            ),

            // Playing bars overlay
            if (isPlaying)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: PlayingBars(
                      color: accent,
                      height: 20,
                      isPaused: isPaused,
                    ),
                  ),
                ),
              ),

            // Title at bottom
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                song.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isPlaying ? accent : Colors.white,
                  shadows: const [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
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
                    width: 130,
                    height: 130,
                    child: thumb.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumb,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: AppColors.surface),
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.surface),
                          )
                        : Container(color: AppColors.surface),
                  ),
                  // Play overlay
                  if (isPlaying)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black38,
                        child: Center(
                          child: PlayingBars(
                            color: accent,
                            height: 22,
                            isPaused: isPaused,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // ── Title ──
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPlaying ? accent : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            // ── Artist ──
            Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Favorite Artist Section Widget ──
class _FavoriteArtistSection extends StatefulWidget {
  final List<FavoriteArtistGroup> groups;
  final AudioState audio;
  final void Function(Song) onPlay;
  final void Function(Song) onMenu;
  final void Function(String?, List<Song>) onPlayAll;
  final void Function(int) onLoadPage;

  const _FavoriteArtistSection({
    required this.groups,
    required this.audio,
    required this.onPlay,
    required this.onMenu,
    required this.onPlayAll,
    required this.onLoadPage,
  });

  @override
  State<_FavoriteArtistSection> createState() => _FavoriteArtistSectionState();
}

class _FavoriteArtistSectionState extends State<_FavoriteArtistSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedTab = 'Top tracks';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          SizedBox(
            height: 380, // Adjusted height for 2x3 grid
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.groups.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                widget.onLoadPage(index);
              },
              itemBuilder: (context, index) {
                final group = widget.groups[index];
                
                return Padding(
                  padding: EdgeInsets.only(
                    left: index > 0 ? 8 : 0,
                    right: index < widget.groups.length - 1 ? 8 : 0,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (group.artistData != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ArtistScreen(
                                    browseId: group.artistData!.browseId,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              if (group.artistData != null && group.artistData!.thumbnail.isNotEmpty) ...[
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    ThumbnailUtils.getHighRes(group.artistData!.thumbnail, size: 100),
                                  ),
                                  backgroundColor: AppColors.surface,
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'MORE FROM',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      group.artistName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Play all button
                              if (_selectedTab == 'Top tracks' && group.artistData != null && group.artistData!.topSongs.isNotEmpty)
                                GestureDetector(
                                  onTap: () => widget.onPlayAll(group.artistData!.topSongsPlaylistId, group.artistData!.topSongs),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.play_arrow_rounded, size: 16, color: AppColors.background),
                                        SizedBox(width: 4),
                                        Text(
                                          'Play all',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.background,
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
                        
                        // Tabs
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _selectedTab = 'Top tracks'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _selectedTab == 'Top tracks' ? Theme.of(context).colorScheme.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Top tracks',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedTab == 'Top tracks' ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _selectedTab = 'Albums'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _selectedTab == 'Albums' ? Theme.of(context).colorScheme.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Albums',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedTab == 'Albums' ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (group.artistData == null && !group.hasError)
                          const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else if (group.hasError)
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Error loading content',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else if (_selectedTab == 'Top tracks' && group.artistData!.topSongs.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text(
                                'No songs found',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else if (_selectedTab == 'Albums' && group.artistData!.albums.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text(
                                'No albums found',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 250, // Enough for 2 rows of squares
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _selectedTab == 'Top tracks' 
                                  ? (group.artistData!.topSongs.length < 6 && group.artistData!.topSongsPlaylistId != null 
                                      ? group.artistData!.topSongs.length + 1 
                                      : group.artistData!.topSongs.take(6).length)
                                  : group.artistData!.albums.take(6).length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, i) {
                                if (_selectedTab == 'Top tracks') {
                                  // Show 'Show all' button in the last spot
                                  if (i == group.artistData!.topSongs.length && group.artistData!.topSongsPlaylistId != null) {
                                    final songs = group.artistData!.topSongs.take(4).toList();
                                    return GestureDetector(
                                      onTap: () {
                                        context.push('/playlist/${group.artistData!.topSongsPlaylistId}?title=${Uri.encodeComponent(group.artistData!.name)}');
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            if (songs.length >= 4)
                                              GridView.count(
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
                                              )
                                            else
                                              Container(color: AppColors.surface),
                                            Container(
                                              color: Colors.black.withValues(alpha: 0.5),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Show all',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  final song = group.artistData!.topSongs[i];
                                  final isPlaying = widget.audio.currentSong?.videoId == song.videoId;
                                  return _SpeedDialCard(
                                    song: song,
                                    isPlaying: isPlaying,
                                    isPaused: !widget.audio.isPlaying,
                                    onTap: () => widget.onPlay(song),
                                    onLongPress: () => widget.onMenu(song),
                                  );
                                } else {
                                  final album = group.artistData!.albums[i];
                                  return _SquareAlbumCard(
                                    album: album,
                                    onTap: () => context.push('/playlist/${album.browseId}?title=${Uri.encodeComponent(album.title)}'),
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                );
              },
            ),
          ),
          
          // Page indicators
          if (widget.groups.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.groups.length,
                  (index) {
                    final active = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.textSecondary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SquareAlbumCard extends StatelessWidget {
  final ArtistAlbum album;
  final VoidCallback onTap;

  const _SquareAlbumCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = ThumbnailUtils.getHighRes(album.thumbnail, size: 400);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed thumbnail
            thumb.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: thumb,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.surface),
                    errorWidget: (_, __, ___) => Container(color: AppColors.surface),
                  )
                : Container(color: AppColors.surface),

            // Gradient overlay for title readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
            ),

            // Title at bottom
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                album.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
