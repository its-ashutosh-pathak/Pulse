import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../data/api/music_api.dart';
import '../../data/models/artist.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/song_action_sheet.dart';
import '../../widgets/playing_bars.dart';

/// Artist screen — pixel-perfect port of ArtistView.jsx.
/// Hero banner with gradient overlay, Play-All, top songs, albums, singles.
class ArtistScreen extends ConsumerStatefulWidget {
  final String browseId;
  const ArtistScreen({super.key, required this.browseId});

  @override
  ConsumerState<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends ConsumerState<ArtistScreen> {
  final _musicApi = MusicApi();
  Artist? _artist;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  @override
  void didUpdateWidget(covariant ArtistScreen old) {
    super.didUpdateWidget(old);
    if (old.browseId != widget.browseId) _loadArtist();
  }

  Future<void> _loadArtist() async {
    setState(() { _loading = true; _error = false; });
    try {
      final artist = await _musicApi.getArtist(widget.browseId);
      if (mounted) setState(() { _artist = artist; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = true; _loading = false; });
    }
  }

  void _playAll() {
    if (_artist == null || _artist!.topSongs.isEmpty) return;
    final notifier = ref.read(audioProvider.notifier);
    notifier.playSong(_artist!.topSongs.first, clearQueue: true);
    for (int i = 1; i < _artist!.topSongs.length; i++) {
      notifier.addToQueue(_artist!.topSongs[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(audioProvider);
    final accent = Theme.of(context).colorScheme.primary;

    if (_loading) return _buildLoading(context);
    if (_error || _artist == null) return _buildError(context);

    final artist = _artist!;
    final heroThumb = ThumbnailUtils.getHighRes(artist.thumbnail, size: 800);

    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          // ── Hero Banner ──
          SliverToBoxAdapter(child: _buildHero(heroThumb, artist, accent)),

          // ── Body ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // About
                if (artist.description.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('About', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(artist.description,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary,
                          height: 1.5)),
                ],

                // Top Songs
                if (artist.topSongs.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('Popular', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...artist.topSongs.take(5).toList().asMap().entries.map(
                    (entry) => _buildSongRow(entry.key, entry.value, audio, accent),
                  ),
                ],

                // Albums
                if (artist.albums.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('Albums', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                ],
              ]),
            ),
          ),

          // Albums horizontal scroll
          if (artist.albums.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: artist.albums.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => _buildAlbumCard(artist.albums[i]),
                ),
              ),
            ),

          // Singles
          if (artist.singles.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: const Text('Singles & EPs', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ),
            ),

          if (artist.singles.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: artist.singles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (_, i) => _buildAlbumCard(artist.singles[i]),
                  ),
                ),
              ),
            ),

          // Bottom padding for mini player
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // ── Hero ──
  Widget _buildHero(String thumb, Artist artist, Color accent) {
    return SizedBox(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          if (thumb.isNotEmpty)
            CachedNetworkImage(
              imageUrl: thumb, fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(color: AppColors.surface),
            )
          else
            Container(color: AppColors.surface),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.6),
                  AppColors.background,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: GlassContainer(
              borderRadius: 50,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.chevronDown, size: 22),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),

          // Info at bottom
          Positioned(
            left: 20, right: 20, bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (artist.subscribers.isNotEmpty)
                  Text('${artist.subscribers} subscribers',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(artist.name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800,
                        letterSpacing: -0.5)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _playAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        accent, AppColors.computeSecondary(accent),
                      ]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 20,
                            color: AppColors.background),
                        const SizedBox(width: 6),
                        Text('Play All', style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700,
                            color: AppColors.background)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Song Row ──
  Widget _buildSongRow(int index, Song song, AudioState audio, Color accent) {
    final isPlaying = audio.currentSong?.videoId == song.videoId;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ref.read(audioProvider.notifier).playSong(song, clearQueue: true),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // Rank / Playing bars
              SizedBox(
                width: 28,
                child: Center(
                  child: isPlaying
                      ? PlayingBars(color: accent, height: 14, isPaused: !audio.isPlaying)
                      : Text('${index + 1}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600,
                              color: isPlaying
                                  ? accent : AppColors.textSecondary)),
                ),
              ),
              const SizedBox(width: 10),
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 44, height: 44,
                  child: CachedNetworkImage(
                    imageUrl: ThumbnailUtils.getHighRes(song.thumbnail),
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.surface),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title / Artist
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: isPlaying ? accent : AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(song.album.isNotEmpty ? song.album : song.artist,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              // Menu
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => SongActionSheet(song: song),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(LucideIcons.moreVertical,
                      size: 16, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Album/Single Card ──
  Widget _buildAlbumCard(ArtistAlbum album) {
    final thumb = ThumbnailUtils.getHighRes(album.thumbnail, size: 400);
    return GestureDetector(
      onTap: () => context.push('/playlist/${album.browseId}'),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    width: 130, height: 130,
                    child: thumb.isNotEmpty
                        ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.surface))
                        : Container(color: AppColors.surface),
                  ),
                  Positioned(
                    right: 6, bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black54),
                      child: const Icon(LucideIcons.disc,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(album.title,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
            Text(album.year,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // ── Loading ──
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
                  icon: const Icon(LucideIcons.chevronDown, size: 28),
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

  // ── Error ──
  Widget _buildError(BuildContext context) {
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
                  icon: const Icon(LucideIcons.chevronDown, size: 28),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.music2, size: 48,
                        color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    const Text("Couldn't load artist",
                        style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go Back'),
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
