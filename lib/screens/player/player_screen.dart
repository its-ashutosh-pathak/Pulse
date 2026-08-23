import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../providers/player_overlay_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/thumbnail_utils.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/toast_utils.dart';
import '../../data/api/music_api.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart' hide RepeatMode;
import '../../providers/audio_provider.dart' as ap show RepeatMode;
import '../../providers/playlist_provider.dart';
import '../../providers/download_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sleep_timer_provider.dart';
import 'widgets/equalizer_sheet.dart';
import 'widgets/sleep_timer_sheet.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/song_action_sheet.dart';
import '../../widgets/song_tile.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';

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

  // FIX 1: ValueNotifier instead of setState for sheet extent
  // Prevents full Scaffold rebuild on every drag pixel
  final _sheetExtentNotifier = ValueNotifier<double>(0.08);
  final _sheetController = DraggableScrollableController();

  // Lyrics
  String _lyricsState = 'idle'; // idle | loading | loaded | error | not-found
  List<_LyricLine>? _parsedLines;
  final _lyricsScrollController = ScrollController();
  final _musicApi = MusicApi();
  final Map<int, GlobalKey> _lyricKeys = {};
  int _lastAutoScrolledIndex = -1;

  // FIX 6: Lyric user scroll tracking with idle timer
  bool _userScrollingLyrics = false;
  Timer? _scrollIdleTimer;
  int _lastScheduledIndex = -1; // FIX 3: guard against repeated postFrameCallbacks

  @override
  void initState() {
    super.initState();
    // FIX 6: Listen to scroll events to detect user interaction
    _lyricsScrollController.addListener(_onLyricsScroll);

    _sheetExtentNotifier.addListener(() {
      final isOpen = _sheetExtentNotifier.value > 0.12;
      if (ref.read(playerQueueOpenProvider) != isOpen) {
        Future.microtask(() => ref.read(playerQueueOpenProvider.notifier).state = isOpen);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
      final song = ref.read(audioProvider).currentSong;
      if (song != null) {
        _fetchLyricsIfNeeded(song);
      }
    });
  }

  void _onLyricsScroll() {
    _scrollIdleTimer?.cancel();
    _userScrollingLyrics = true;
    // Resume auto-scroll 2.5 seconds after user stops scrolling
    _scrollIdleTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _userScrollingLyrics = false;
        _lastAutoScrolledIndex = -1; // force re-scroll to active line
      }
    });
  }

  @override
  void dispose() {
    _sheetExtentNotifier.dispose();
    _sheetController.dispose();
    _lyricsScrollController.dispose();
    _scrollIdleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioData = ref.watch(audioProvider.select((a) => (
      song: a.currentSong,
      isPlaying: a.isPlaying,
      isLoading: a.isLoading,
      isShuffled: a.isShuffled,
      repeatMode: a.repeatMode,
      queue: a.queue,
    )));
    final song = audioData.song;
    final accent = Theme.of(context).colorScheme.primary;

    if (song == null) return _buildNoSong(context, accent);

    final screenHeight = MediaQuery.of(context).size.height;
    // Header is roughly 60px. We need at least that much space.
    final minExtent = (65.0 / screenHeight).clamp(0.11, 0.3);
    final maxExtent = (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? 0.515 : 0.415;

    ref.listen(audioProvider, (prev, next) {
      if (next.currentSong != null && next.currentSong?.videoId != prev?.currentSong?.videoId) {
        _fetchLyricsIfNeeded(next.currentSong!);
      }
    });

    ref.listen(sleepTimerProvider, (prev, next) {
      if (next.isExpired && (prev == null || !prev.isExpired)) {
        ToastUtils.show(context, 'Sleep timer ended');
        ref.read(sleepTimerProvider.notifier).clearExpired();
      }
    });

    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 800);
    // Use a tiny image for the blur to reduce GPU math during transition
    final blurThumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 120);

    // FIX 2: Use .select() so only the Like button rebuilds when liked status changes
    final isLiked = ref.watch(
      playlistProvider.select((state) =>
        state.playlists
            .where((p) => p.name == 'Liked Songs')
            .any((p) => p.songs.any((s) => s.videoId == song.videoId)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // FIX 4: RepaintBoundary caches the blurred background as its own layer
          // It won't repaint when controls/seek bar update
          if (blurThumb.isNotEmpty)
            Positioned.fill(
              child: RepaintBoundary(
                child: SizedBox.expand(
                  child: _BlurredBackground(thumb: blurThumb),
                ),
              ),
            ),

          // Dark gradient overlay — also wrapped in RepaintBoundary
          Positioned.fill(
            child: RepaintBoundary(
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
          ),

          // ── Content ──
          // FIX 1: ValueListenableBuilder only rebuilds the Opacity+Scale wrapper,
          // NOT the controls, seek bar, album art, etc.
          ValueListenableBuilder<double>(
            valueListenable: _sheetExtentNotifier,
            builder: (context, sheetExtent, child) {
              final fade = (1.0 - (sheetExtent - 0.11) / 0.29).clamp(0.4, 1.0);
              final scale = (1.0 - ((sheetExtent - 0.11) / 0.29) * 0.1).clamp(0.9, 1.0);
              return SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (_sheetExtentNotifier.value > 0.11) {
                      _sheetController.animateTo(0.11, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  },
                  child: Opacity(
                    opacity: fade,
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: Column(
              children: [
                // ── Header ──
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! > 5) { // Downward swipe threshold
                      ref.read(playerOverlayProvider.notifier).state = false;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => ref.read(playerOverlayProvider.notifier).state = false,
                              icon: const Icon(LucideIcons.chevronDown, size: 28),
                            ),
                          ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppLocalizations.of(context)!.playerAppName,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w800,
                                    color: Theme.of(context).colorScheme.primary, letterSpacing: 2)),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => launchUrl(
                                Uri.parse('https://itsashutoshpathak.vercel.app/'),
                                mode: LaunchMode.externalApplication,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(AppLocalizations.of(context)!.playerMadeWithHeartBy,
                                          style: TextStyle(
                                              fontSize: 9, color: AppColors.textSecondary),
                                          maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ),
                                    Flexible(
                                      child: Text(AppLocalizations.of(context)!.playerAuthorName,
                                          style: TextStyle(
                                              fontSize: 9, fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.primary),
                                          maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Builder(
                            builder: (context) {
                              final isEnabled = ref.watch(settingsProvider).equalizerEnabled;
                              final timerState = ref.watch(sleepTimerProvider);
                              final isTimerActive = timerState.isActive;
                              
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      showModalBottomSheet(
                                        useRootNavigator: true, 
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const SleepTimerSheet(),
                                      );
                                    },
                                    icon: Icon(
                                      LucideIcons.moon,
                                      size: 22,
                                      color: isTimerActive ? Theme.of(context).colorScheme.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Hide keyboard if it was open on the underlying screen
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      showModalBottomSheet(useRootNavigator: true, 
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const EqualizerSheet(),
                                      );
                                    },
                                    icon: Icon(
                                      LucideIcons.sliders, 
                                      size: 22,
                                      color: isEnabled ? Theme.of(context).colorScheme.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              );
                            }
                          ),
                        ),
                      ],
                    ),
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
                      onHorizontalDragUpdate: (details) {},
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
                            ? Consumer(
                                builder: (context, ref, _) {
                                  final audioState = ref.watch(audioProvider);
                                  return _buildLyricsView(audioState, Theme.of(context).colorScheme.primary);
                                },
                              )
                            : _buildArtView(thumb, song, Theme.of(context).colorScheme.primary),
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
                                onTap: () => showModalBottomSheet(useRootNavigator: true, 
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
                      const _SeekBar(),

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
                                  color: audioData.isShuffled ? accent : Colors.white),
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
                                  child: audioData.isLoading
                                      ? SizedBox(
                                          width: 28, height: 28,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 3, color: accent))
                                      : Icon(
                                          audioData.isPlaying
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
                                audioData.repeatMode == ap.RepeatMode.one
                                    ? LucideIcons.repeat1
                                    : LucideIcons.repeat,
                                size: 24,
                                color: audioData.repeatMode != ap.RepeatMode.off
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
                const SizedBox(height: 70),
              ],
            ),
          ),

          // ── Draggable Queue ──
          // FIX 1: Update ValueNotifier instead of calling setState
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              _sheetExtentNotifier.value = notification.extent;
              return true;
            },
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: minExtent,
              minChildSize: minExtent,
              maxChildSize: maxExtent,
              snap: true,
              builder: (context, scrollController) {
                return ValueListenableBuilder<double>(
                  valueListenable: _sheetExtentNotifier,
                  builder: (context, extent, _) {
                    return _buildUpNext(audioData.queue, accent, scrollController, extent, minExtent, maxExtent);
                  },
                );
              },
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // FIX 4: RepaintBoundary on the art itself so it's cached as its own layer
          RepaintBoundary(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? 0.85 : 1.0,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                    fit: StackFit.expand,
                    children: [
                      thumb.isNotEmpty
                          ? (!thumb.startsWith('http')
                              ? Image.file(File(thumb), fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                              : CachedNetworkImage(
                                  imageUrl: thumb, fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      Container(color: AppColors.surface)))
                          : Container(color: AppColors.surface),

                      // FIX 5: Only the download overlay uses a Consumer — avoids
                      // rebuilding the whole art view when other songs are downloading
                      Consumer(
                        builder: (context, ref, _) {
                          final downloads = ref.watch(downloadProvider);
                          final isDownloading = downloads.activeDownloads.containsKey(song.videoId);
                          if (!isDownloading) return const SizedBox.shrink();
                          final downloadProgress = downloads.activeDownloads[song.videoId]!.progress;
                          return Container(
                            alignment: Alignment.bottomCenter,
                            decoration: const BoxDecoration(color: Colors.black54),
                            child: FractionallySizedBox(
                              heightFactor: downloadProgress.clamp(0.0, 1.0),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: accent.withValues(alpha: 0.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ),
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
                    Text(AppLocalizations.of(context)!.playerSwipeForLyrics,
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

    // FIX 3 + FIX 6: Only schedule postFrameCallback when index actually changes
    // AND only auto-scroll when the user isn't manually scrolling
    if (activeIndex >= 0 && activeIndex != _lastScheduledIndex) {
      _lastScheduledIndex = activeIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_userScrollingLyrics) return; // user is reading, don't interrupt
        if (activeIndex != _lastAutoScrolledIndex) {
          _lastAutoScrolledIndex = activeIndex;
          final key = _lyricKeys[activeIndex];
          if (key != null && key.currentContext != null) {
            Scrollable.ensureVisible(
              key.currentContext!,
              alignment: 0.5,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
      });
    }

    return Padding(
      key: const ValueKey('lyrics'),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? 0.85 : 1.0,
          child: AspectRatio(
          aspectRatio: 1,
          child: GlassContainer(
            borderRadius: 20,
            blur: 20,
            child: _lyricsState == 'loading'
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _lyricsState == 'error' || _parsedLines == null || _parsedLines!.isEmpty
                    ? Center(child: Text(AppLocalizations.of(context)!.playerNoLyrics, style: const TextStyle(color: Colors.white70)))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                        controller: _lyricsScrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(_parsedLines!.length, (i) {
                            _lyricKeys[i] ??= GlobalKey();
                            final line = _parsedLines![i];
                            final isActive = i == activeIndex;
                            return Padding(
                              key: _lyricKeys[i],
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line.text.isEmpty ? '\u00a0' : line.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isActive ? 18 : 15,
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                  color: isActive ? accent : Colors.white38,
                                  height: 1.5,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
          ),
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
  // Only renders up to 25 songs at a time (sliding window)
  static const int _queueWindowSize = 25;

  Widget _buildUpNext(List<Song> queue, Color accent, ScrollController scrollController, double sheetExtent, double minExtent, double maxExtent) {
    // Sliding window: always show first 25 from the live queue.
    // As songs play they're removed from the front, so this naturally
    // slides forward — no index tracking needed.
    final visibleQueue = queue.length > _queueWindowSize
        ? queue.sublist(0, _queueWindowSize)
        : queue;

    final openFraction = ((sheetExtent - minExtent) / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final double blurValue = openFraction * 24.0;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurValue > 0.0 ? blurValue : 0.001,
            sigmaY: blurValue > 0.0 ? blurValue : 0.001,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F).withValues(alpha: openFraction * 0.24),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: Colors.white.withValues(alpha: openFraction * 0.12),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // ── Static Header & Drag Handle ──
                GestureDetector(
                  onTap: () {
                    _sheetController.animateTo(maxExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  },
                  onVerticalDragUpdate: (details) {
                    final newSize = _sheetController.size - details.primaryDelta! / MediaQuery.of(context).size.height;
                    _sheetController.jumpTo(newSize.clamp(minExtent, maxExtent));
                  },
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! < -300 || _sheetController.size > minExtent + 0.09) {
                      _sheetController.animateTo(maxExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    } else {
                      _sheetController.animateTo(minExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  },
                  child: Container(
                    color: Colors.transparent, // catches gestures
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.playerUpNext,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Scrollable Queue List ──
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Opacity(
                          opacity: ((sheetExtent - 0.11) / 0.12).clamp(0.0, 1.0),
                          child: queue.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Center(
                                  child: Text(AppLocalizations.of(context)!.playerNoTracksInQueue,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                ReorderableListView.builder(
                                shrinkWrap: true,
                                buildDefaultDragHandles: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? false : true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 16),
                                itemCount: visibleQueue.length,
                                onReorder: (oldIndex, newIndex) {
                                  ref.read(audioProvider.notifier).reorderQueue(oldIndex, newIndex);
                                },
                                itemBuilder: (_, i) {
                                  final s = visibleQueue[i];
                                  return Dismissible(
                                    key: ValueKey('${s.id}_$i'),
                                    direction: DismissDirection.horizontal,
                                    onDismissed: (_) {
                                      ref.read(audioProvider.notifier).removeFromQueue(i);
                                    },
                                    background: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                                        child: Container(
                                          color: Colors.red.withValues(alpha: 0.1),
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: const Icon(LucideIcons.trash2, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    secondaryBackground: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                                        child: Container(
                                          color: Colors.red.withValues(alpha: 0.1),
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: const Icon(LucideIcons.trash2, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    child: SongTile(
                                      song: s,
                                      onTap: () => ref.read(audioProvider.notifier).playFromQueue(i),
                                      onLongPress: () => showModalBottomSheet(useRootNavigator: true, 
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
                                    ),
                                  );
                                },
                              ),
                                const SizedBox(height: 32),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSong(BuildContext context, Color accent) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => ref.read(playerOverlayProvider.notifier).state = false,
                    icon: const Icon(LucideIcons.chevronDown, size: 28),
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.playerNoMusicPlaying,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.playerPickAVibe,
                        style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS))
                      ElevatedButton(
                        onPressed: () {
                          ref.read(playerOverlayProvider.notifier).state = false;
                          context.go('/');
                        },
                        child: Text(AppLocalizations.of(context)!.playerGoHome),
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
    _lastAutoScrolledIndex = -1;
    _lastScheduledIndex = -1;
    _userScrollingLyrics = false;
    _scrollIdleTimer?.cancel();

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

// ── Extracted background widget so it never rebuilds with player state ──
// FIX 4: Stateless widget with its own RepaintBoundary layer
class _BlurredBackground extends StatelessWidget {
  final String thumb;
  const _BlurredBackground({required this.thumb});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: (!thumb.startsWith('http'))
          ? Image.file(
              File(thumb), fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.5),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (_, __, ___) => Container(color: AppColors.background),
            )
          : CachedNetworkImage(
              imageUrl: thumb, fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.5),
              colorBlendMode: BlendMode.darken,
              errorWidget: (_, __, ___) =>
                  Container(color: AppColors.background),
            ),
    );
  }
}

class _SeekBar extends ConsumerStatefulWidget {
  const _SeekBar();
  @override
  ConsumerState<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends ConsumerState<_SeekBar> {
  bool _isDragging = false;
  double _dragProgress = 0;

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(audioProvider);
    final displayProgress = _isDragging
        ? Duration(milliseconds: _dragProgress.toInt())
        : audio.progress;
    final progressFraction = audio.duration.inMilliseconds > 0
        ? (displayProgress.inMilliseconds / audio.duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: RepaintBoundary(
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
                onChangeStart: (_) => setState(() => _isDragging = true),
                onChanged: (v) => setState(() => _dragProgress = v * audio.duration.inMilliseconds),
                onChangeEnd: (v) {
                  setState(() => _isDragging = false);
                  ref.read(audioProvider.notifier).seek(Duration(
                      milliseconds: (v * audio.duration.inMilliseconds).toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(displayProgress.inSeconds),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text(formatDuration(audio.duration.inSeconds),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
