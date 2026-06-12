import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/thumbnail_utils.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';

/// Mini player bar — port of Player.jsx.
/// Fixed at the bottom, shows cover art, marquee title, controls, and progress line.
/// Background: blurred cover art with dark overlay — same technique as full player.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioProvider);
    final song = audio.currentSong;
    if (song == null) return const SizedBox.shrink();

    final accent = Theme.of(context).colorScheme.primary;
    final thumb = ThumbnailUtils.getHighRes(song.thumbnail, size: 200);
    final progressPercent = audio.duration.inMilliseconds > 0
        ? (audio.progress.inMilliseconds / audio.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    // Check liked status
    final _ = ref.watch(playlistProvider);
    final isLiked =
        ref.read(playlistProvider.notifier).isLiked(song.videoId);

    return GestureDetector(
      onTap: () => context.push('/player'),
      child: SizedBox(
        height: 68,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background ──
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(color: const Color(0x66000000)), // 40% Black tint
                ),
              ),
            ),

            // ── Thin border overlay ──
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                    width: 0.8,
                  ),
                ),
              ),
            ),

            // ── Main content ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  // ── Cover art thumbnail ──
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 40, height: 40,
                      child: thumb.isNotEmpty
                          ? (!thumb.startsWith('http')
                              ? Image.file(File(thumb), fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.surface))
                              : CachedNetworkImage(
                                  imageUrl: thumb, fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      Container(color: AppColors.surface)))
                          : Container(color: AppColors.surface),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ── Title + Artist ──
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Marquee title
                        SizedBox(
                          height: 18,
                          child: ClipRect(
                            child: ShaderMask(
                              shaderCallback: (rect) => const LinearGradient(
                                colors: [
                                  Colors.transparent, Colors.white,
                                  Colors.white, Colors.transparent,
                                ],
                                stops: [0.0, 0.05, 0.95, 1.0],
                              ).createShader(rect),
                              blendMode: BlendMode.dstIn,
                              child: _MarqueeText(
                                text: song.title,
                                style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(song.artist,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ── Controls ──
                  GestureDetector(
                    onTap: () => ref
                        .read(playlistProvider.notifier)
                        .toggleLike(song),
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 22,
                      color: isLiked ? accent : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => ref.read(audioProvider.notifier).playPrev(),
                    child: const Icon(Icons.skip_previous,
                        size: 28, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        ref.read(audioProvider.notifier).togglePlay(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: audio.isLoading
                            ? SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(accent),
                                ))
                            : Icon(
                                audio.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 24,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        ref.read(audioProvider.notifier).playNext(),
                    child: const Icon(Icons.skip_next,
                        size: 28, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ── Progress line (bottom) ──
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SizedBox(
                height: 2,
                child: Stack(
                  children: [
                    Container(color: Colors.white10),
                    FractionallySizedBox(
                      widthFactor: progressPercent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: accent,
                          boxShadow: [
                            BoxShadow(
                                color: accent.withValues(alpha: 0.5),
                                blurRadius: 10),
                          ],
                        ),
                      ),
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

// ── Marquee Text (auto-scrolling for long song titles) ──
class _MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _MarqueeText({required this.text, required this.style});

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  late AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  void _startScroll() {
    if (!mounted) return;
    if (_controller.hasClients &&
        _controller.position.maxScrollExtent > 0) {
      _animation.repeat();
      _animation.addListener(() {
        if (_controller.hasClients) {
          _controller.jumpTo(
              _animation.value * _controller.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void didUpdateWidget(_MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _animation.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if word count is <= 2
    final wordCount = widget.text.trim().split(RegExp(r'\s+')).length;
    
    if (wordCount <= 2) {
      // Text has 2 words or fewer, no need for marquee
      return Text(
        widget.text, 
        style: widget.style, 
        maxLines: 1, 
        overflow: TextOverflow.ellipsis,
      );
    }

    // Text has more than 2 words, animate marquee
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          Text(widget.text, style: widget.style),
          const SizedBox(width: 40),
          Text(widget.text, style: widget.style),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
