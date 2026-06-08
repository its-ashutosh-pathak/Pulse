import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../core/utils/formatters.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart' hide RepeatMode;
import '../../providers/audio_provider.dart' as ap show RepeatMode;
import '../../providers/playlist_provider.dart';
import '../../providers/download_provider.dart';
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
  double _flipDirection = 1.0;
  bool _isDragging = false;
  double _dragProgress = 0;
  double _sheetExtent = 0.08; // Min extent for the queue handle

  // Lyrics
  String _lyricsState = 'idle'; // idle | loading | loaded | error | not-found
  List<_LyricLine>? _parsedLines;
  final _lyricsScrollController = ScrollController();
  final _musicApi = MusicApi();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final song = ref.read(audioProvider).currentSong;
      if (song != null) {
        _fetchLyricsIfNeeded(song);
      }
    });
  }

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

    // Provide listener for song changes to fetch lyrics rather than in build
    ref.listen(audioProvider, (prev, next) {
      if (next.currentSong != null && next.currentSong?.videoId != prev?.currentSong?.videoId) {
        _fetchLyricsIfNeeded(next.currentSong!);
      }
    });

    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 800);
    final displayProgress = _isDragging
        ? Duration(milliseconds: _dragProgress.toInt())
        : audio.progress;
    final progressFraction = audio.duration.inMilliseconds > 0
        ? (displayProgress.inMilliseconds / audio.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    // Watch playlist state so Like button updates reactively
    // ignore: unused_local_variable
    final playlistState = ref.watch(playlistProvider);
    final isLiked =
        ref.read(playlistProvider.notifier).isLiked(song.videoId);

    return Scaffold(
      body: Stack(
        children: [
          // ── Background tint ──
          if (thumb.isNotEmpty)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: CachedNetworkImage(
                  imageUrl: thumb, fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.5),
                  colorBlendMode: BlendMode.darken,
                  errorWidget: (_, __, ___) =>
                      Container(color: AppColors.background),
                ),
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
            child: Opacity(
              opacity: (1.0 - (_sheetExtent - 0.11) / 0.29).clamp(0.4, 1.0),
              child: Transform.scale(
                scale: (1.0 - ((_sheetExtent - 0.11) / 0.29) * 0.1).clamp(0.9, 1.0),
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
                          GestureDetector(
                            onTap: () => launchUrl(
                              Uri.parse('https://itsashutoshpathak.vercel.app/'),
                              mode: LaunchMode.externalApplication,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Made with \u2764\ufe0f by ',
                                    style: TextStyle(
                                        fontSize: 9, color: AppColors.textSecondary)),
                                Text('Ashutosh Pathak',
                                    style: TextStyle(
                                        fontSize: 9, fontWeight: FontWeight.bold, color: accent)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48), // balance
                    ],
                  ),
                ),

                const SizedBox(height: 0),

                // ── Album Art / Lyrics ──
                Expanded(
                  flex: 8,
                  child: Transform.translate(
                    offset: const Offset(0, -16),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (details) {}, // Helps win the gesture arena
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null && details.primaryVelocity!.abs() > 100) {
                          _flipDirection = details.primaryVelocity! > 0 ? 1.0 : -1.0;
                          setState(() => _showLyrics = !_showLyrics);
                        }
                      },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                        return Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final rotateAnim = Tween(begin: math.pi * _flipDirection, end: 0.0).animate(animation);
                        return AnimatedBuilder(
                          animation: rotateAnim,
                          child: child,
                          builder: (context, child) {
                            final isUnder = (ValueKey(_showLyrics ? 'lyrics' : 'art') != child?.key);
                            final angle = isUnder ? math.min(rotateAnim.value, math.pi / 2) : rotateAnim.value;
                            return Transform(
                              transform: Matrix4.rotationY(angle)..setEntry(3, 2, 0.002),
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                        );
                      },
                      child: _showLyrics
                          ? _buildLyricsView(audio, accent)
                          : _buildArtView(thumb, song, accent),
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 8),

                Transform.translate(
                  offset: const Offset(0, -16),
                  child: Column(
                    children: [
                      // ── Song info ──
                      Transform.translate(
                        offset: const Offset(0, -16),
                        child: Padding(
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
                                  isLiked ? Icons.favorite : Icons.favorite_border, size: 24,
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
                      ),

                      const SizedBox(height: 8),

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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => ref.read(audioProvider.notifier).toggleShuffle(),
                              child: Icon(LucideIcons.shuffle, size: 24,
                                  color: audio.isShuffled ? accent : Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(audioProvider.notifier).playPrev(),
                              child: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(audioProvider.notifier).togglePlay(),
                              child: Container(
                                width: 72, height: 72,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: audio.isLoading
                                      ? SizedBox(
                                          width: 28, height: 28,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 3, color: accent))
                                      : Icon(
                                          audio.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 44, color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(audioProvider.notifier).playNext(),
                              child: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => ref.read(audioProvider.notifier).toggleRepeat(),
                              child: Icon(
                                audio.repeatMode == ap.RepeatMode.one
                                    ? LucideIcons.repeat1
                                    : LucideIcons.repeat,
                                size: 24,
                                color: audio.repeatMode != ap.RepeatMode.off
                                    ? accent : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 2),

                // Space for the queue handle
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),

      // ── Draggable Queue ──
      NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          setState(() => _sheetExtent = notification.extent);
          return true;
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.11,
          minChildSize: 0.11,
          maxChildSize: 0.4,
          snap: true,
          builder: (context, scrollController) {
            return _buildUpNext(audio, accent, scrollController);
          },
        ),
      ),
    ],
  ),
    );
  }

  // ── Album Art view ──
  Widget _buildArtView(String thumb, Song song, Color accent) {
    final downloads = ref.watch(downloadProvider);
    final isDownloading = downloads.activeDownloads.containsKey(song.videoId);
    final downloadProgress = isDownloading ? downloads.activeDownloads[song.videoId]!.progress : 0.0;

    return Padding(
      key: const ValueKey('art'),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  thumb.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: thumb, fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              Container(color: AppColors.surface))
                      : Container(color: AppColors.surface),
                  if (isDownloading)
                    Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(color: Colors.black54),
                      child: FractionallySizedBox(
                        heightFactor: downloadProgress.clamp(0.0, 1.0),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: accent.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
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
                    const Text('Swipe for lyrics',
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
    final activeIndex = _findActiveLineIndex(audio.progress.inMilliseconds / 1000.0);

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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AspectRatio(
        aspectRatio: 1,
        child: GlassContainer(
        borderRadius: 20, blur: 20,
        padding: const EdgeInsets.all(20),
        child: _lyricsState == 'loading'
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _lyricsState == 'error' || _parsedLines == null || _parsedLines!.isEmpty
                ? const Center(child: Text('No lyrics available', style: TextStyle(color: Colors.white70)))
                : ListView.builder(
                    controller: _lyricsScrollController,
                    itemCount: _parsedLines!.length,
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
  Widget _buildUpNext(AudioState audio, Color accent, ScrollController scrollController) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            primary: false,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.background,
            toolbarHeight: 60,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text('Up Next',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: accent)),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Opacity(
              opacity: ((_sheetExtent - 0.11) / 0.12).clamp(0.0, 1.0),
              child: audio.queue.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(
                      child: Text('No tracks in queue',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ),
                  )
                : ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    itemCount: audio.queue.length,
                    onReorder: (oldIndex, newIndex) {
                      ref.read(audioProvider.notifier).reorderQueue(oldIndex, newIndex);
                    },
                    itemBuilder: (_, i) {
                      final s = audio.queue[i];
                      return SongTile(
                        key: ValueKey('${s.id}_$i'),
                        song: s,
                        onTap: () => ref.read(audioProvider.notifier).playFromQueue(i),
                        onLongPress: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => SongActionSheet(song: s),
                        ),
                        trailing: ReorderableDragStartListener(
                          index: i,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(LucideIcons.equal,
                                size: 20, color: AppColors.textSecondary),
                          ),
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

    _musicApi.getLyricsBySong(song).then((lyrics) {
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
