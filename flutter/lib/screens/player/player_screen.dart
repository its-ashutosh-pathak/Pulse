import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../core/utils/formatters.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart' hide RepeatMode;
import '../../providers/audio_provider.dart' as ap show RepeatMode;
import '../../providers/playlist_provider.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/song_action_sheet.dart';
import '../../widgets/song_tile.dart';

/// Full-screen player — port of PlayerView.jsx.
/// Album art with lyrics flip, seek bar, main controls, up-next queue.
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _showLyrics = false;
  bool _isDragging = false;
  double _dragProgress = 0;

  // Lyrics
  String _lyricsState = 'idle'; // idle | loading | loaded | error | not-found
  List<_LyricLine>? _parsedLines;
  final _lyricsScrollController = ScrollController();
  final _musicApi = MusicApi();

  @override
  void dispose() {
    _lyricsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(audioProvider);
    final song = audio.currentSong;
    final accent = Theme.of(context).colorScheme.primary;

    if (song == null) return _buildNoSong(context, accent);

    // Fetch lyrics when song changes
    _fetchLyricsIfNeeded(song);

    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 800);
    final displayProgress = _isDragging
        ? Duration(milliseconds: _dragProgress.toInt())
        : audio.progress;
    final progressFraction = audio.duration.inMilliseconds > 0
        ? (displayProgress.inMilliseconds / audio.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    final isLiked =
        ref.read(playlistProvider.notifier).isLiked(song.videoId);

    return Scaffold(
      body: Stack(
        children: [
          // ── Background tint ──
          if (thumb.isNotEmpty)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: thumb, fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.7),
                colorBlendMode: BlendMode.darken,
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.background),
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.background.withValues(alpha: 0.85), AppColors.background],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(LucideIcons.chevronDown, size: 28),
                      ),
                      Column(
                        children: [
                          Text('PULSE',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w800,
                                  color: accent, letterSpacing: 2)),
                          const Text('Made with ❤️ by Ashutosh Pathak',
                              style: TextStyle(
                                  fontSize: 9, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(width: 48), // balance
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Album Art / Lyrics ──
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onTap: () {
                      if (_lyricsState == 'loaded') {
                        setState(() => _showLyrics = !_showLyrics);
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _showLyrics && _parsedLines != null
                          ? _buildLyricsView(audio, accent)
                          : _buildArtView(thumb, song, accent),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Song info ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song.title,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700,
                                    color: accent)),
                            const SizedBox(height: 4),
                            Text(song.artist,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => ref.read(playlistProvider.notifier).toggleLike(song),
                        child: Icon(
                          LucideIcons.heart, size: 24,
                          color: isLiked ? accent : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => SongActionSheet(song: song),
                        ),
                        child: const Icon(LucideIcons.moreVertical,
                            size: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Seek bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: _isDragging ? 5 : 3,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: _isDragging ? 8 : 5),
                        ),
                        child: Slider(
                          value: progressFraction,
                          onChangeStart: (_) =>
                              setState(() => _isDragging = true),
                          onChanged: (v) => setState(() =>
                              _dragProgress =
                                  v * audio.duration.inMilliseconds),
                          onChangeEnd: (v) {
                            setState(() => _isDragging = false);
                            ref.read(audioProvider.notifier).seek(Duration(
                                milliseconds:
                                    (v * audio.duration.inMilliseconds)
                                        .toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(displayProgress.inSeconds),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            Text(formatDuration(audio.duration.inSeconds),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Controls ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(audioProvider.notifier).toggleShuffle(),
                        child: Icon(LucideIcons.shuffle, size: 24,
                            color: audio.isShuffled ? accent : const Color(0xFFAAAAAA)),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(audioProvider.notifier).playPrev(),
                        child: const Icon(LucideIcons.skipBack, size: 26, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(audioProvider.notifier).togglePlay(),
                        child: Container(
                          width: 64, height: 64,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: Center(
                            child: audio.isLoading
                                ? SizedBox(
                                    width: 28, height: 28,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3, color: accent))
                                : Icon(
                                    audio.isPlaying
                                        ? LucideIcons.pause
                                        : LucideIcons.play,
                                    size: 48, color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(audioProvider.notifier).playNext(),
                        child: const Icon(LucideIcons.skipForward, size: 26, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(audioProvider.notifier).toggleRepeat(),
                        child: Icon(
                          audio.repeatMode == ap.RepeatMode.one
                              ? LucideIcons.repeat1
                              : LucideIcons.repeat,
                          size: 24,
                          color: audio.repeatMode != ap.RepeatMode.off
                              ? accent : const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Up Next queue ──
                Expanded(
                  flex: 3,
                  child: _buildUpNext(audio, accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Album Art view ──
  Widget _buildArtView(String thumb, Song song, Color accent) {
    return Padding(
      key: const ValueKey('art'),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: thumb.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: thumb, fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.surface))
                  : Container(color: AppColors.surface),
            ),
          ),
          if (_lyricsState == 'loaded')
            Positioned(
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.music2, size: 12, color: accent),
                    const SizedBox(width: 4),
                    const Text('Tap for lyrics',
                        style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Lyrics view ──
  Widget _buildLyricsView(AudioState audio, Color accent) {
    final activeIndex = _findActiveLineIndex(audio.progress.inSeconds.toDouble());

    // Auto-scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (activeIndex >= 0 && _lyricsScrollController.hasClients) {
        final offset = (activeIndex * 44.0) -
            (_lyricsScrollController.position.viewportDimension / 2);
        _lyricsScrollController.animateTo(
          offset.clamp(0, _lyricsScrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Padding(
      key: const ValueKey('lyrics'),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: GlassContainer(
        borderRadius: 20, blur: 20,
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          controller: _lyricsScrollController,
          itemCount: _parsedLines?.length ?? 0,
          itemBuilder: (_, i) {
            final line = _parsedLines![i];
            final isActive = i == activeIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                line.text.isEmpty ? '\u00a0' : line.text,
                style: TextStyle(
                  fontSize: isActive ? 18 : 15,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? accent : Colors.white38,
                  height: 1.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int _findActiveLineIndex(double posSeconds) {
    if (_parsedLines == null) return -1;
    for (int i = _parsedLines!.length - 1; i >= 0; i--) {
      if (_parsedLines![i].time != null && posSeconds >= _parsedLines![i].time!) {
        return i;
      }
    }
    return -1;
  }

  // ── Up Next ──
  Widget _buildUpNext(AudioState audio, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text('Up Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                  color: accent)),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: audio.queue.isEmpty
              ? const Center(
                  child: Text('No tracks in queue',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 32),
                  itemCount: audio.queue.length.clamp(0, 10),
                  itemBuilder: (_, i) {
                    final s = audio.queue[i];
                    return SongTile(
                      song: s,
                      onTap: () => ref.read(audioProvider.notifier).playSong(s),
                      onLongPress: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => SongActionSheet(song: s),
                      ),
                      trailing: GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => SongActionSheet(song: s),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(LucideIcons.moreVertical,
                              size: 16, color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNoSong(BuildContext context, Color accent) {
    return Scaffold(
      body: SafeArea(
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
                    const Text('No music playing',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('Pick a vibe from your library or home',
                        style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Go Home'),
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

  // ── Lyrics fetching ──
  String? _lastLyricsId;

  void _fetchLyricsIfNeeded(Song song) {
    if (_lastLyricsId == song.videoId) return;
    _lastLyricsId = song.videoId;
    _lyricsState = 'loading';
    _parsedLines = null;

    _musicApi.getLyrics(song.videoId).then((lyrics) {
      if (!mounted || _lastLyricsId != song.videoId) return;
      if (lyrics != null && lyrics.isSynced && lyrics.syncedLines != null) {
        setState(() {
          _parsedLines = lyrics.syncedLines!
              .map((l) => _LyricLine(time: l.timestamp, text: l.text))
              .toList();
          _lyricsState = 'loaded';
        });
      } else if (lyrics != null && lyrics.plainText != null) {
        setState(() {
          _parsedLines = lyrics.plainText!
              .split('\n')
              .map((line) => _LyricLine(time: null, text: line.trim()))
              .toList();
          _lyricsState = 'loaded';
        });
      } else {
        setState(() => _lyricsState = 'not-found');
      }
    }).catchError((_) {
      if (mounted) setState(() => _lyricsState = 'error');
    });
  }
}

class _LyricLine {
  final double? time;
  final String text;
  _LyricLine({this.time, required this.text});
}
