import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/utils/toast_utils.dart';
import '../data/models/song.dart';
import '../providers/audio_provider.dart';
import 'song_tile.dart';

/// Wraps a [SongTile] with a Spotify-style "swipe to add to queue" gesture.
///
/// Behaviour:
///   - User drags left OR right.
///   - The tile follows the finger up to 60% of screen width.
///   - On release (or after threshold hit) it snaps back to position.
///   - Once the drag reaches the 60% threshold the song is added to the queue,
///     a haptic tick fires, and a brief toast confirms it.
///   - Does NOT dismiss/remove the tile — it stays in place.
class SwipeToQueueTile extends ConsumerStatefulWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final bool isPlaying;
  final bool showDuration;
  final int? index;

  const SwipeToQueueTile({
    super.key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.trailing,
    this.isPlaying = false,
    this.showDuration = false,
    this.index,
  });

  @override
  ConsumerState<SwipeToQueueTile> createState() => _SwipeToQueueTileState();
}

class _SwipeToQueueTileState extends ConsumerState<SwipeToQueueTile>
    with SingleTickerProviderStateMixin {
  // How far (fraction of screen width) the tile can be dragged before
  // the queue-add fires and the tile snaps back.
  static const double _triggerFraction = 0.40;

  double _dragOffset = 0.0;
  bool _triggered = false;
  late AnimationController _snapController;
  Animation<double>? _snapAnimation;
  VoidCallback? _snapListener;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_snapController.isAnimating) return;
    final maxDrag = MediaQuery.of(context).size.width * _triggerFraction;
    setState(() {
      _dragOffset =
          (_dragOffset + details.delta.dx).clamp(-maxDrag, maxDrag);
    });

    // Fire once when threshold is first reached
    if (!_triggered && _dragOffset.abs() >= maxDrag) {
      _triggered = true;
      HapticFeedback.mediumImpact();
      ref.read(audioProvider.notifier).addToQueue(widget.song);
      _showQueueSnackbar();
    }
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_dragOffset == 0.0) return;
    // Remove previous listener before creating a new animation,
    // preventing listener accumulation across multiple swipes.
    if (_snapListener != null && _snapAnimation != null) {
      _snapAnimation!.removeListener(_snapListener!);
    }
    final startOffset = _dragOffset;
    _snapAnimation = Tween<double>(begin: startOffset, end: 0.0).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.elasticOut),
    );
    _snapListener = () {
      if (mounted) setState(() => _dragOffset = _snapAnimation!.value);
    };
    _snapAnimation!.addListener(_snapListener!);
    _snapController.forward(from: 0.0).then((_) {
      if (mounted) setState(() => _triggered = false);
    });
  }

  void _showQueueSnackbar() {
    ToastUtils.show(
      context,
      '"${widget.song.title}" added to queue',
      action: const Icon(
        LucideIcons.listMusic,
        size: 16,
        color: Color(0xFF1DB954),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxDrag = MediaQuery.of(context).size.width * _triggerFraction;
    final progress = (_dragOffset.abs() / maxDrag).clamp(0.0, 1.0);
    final accent = Theme.of(context).colorScheme.primary;
    final isLeft = _dragOffset < 0;

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          // ── Background hint that appears during swipe ──
          // Styled like the queue Dismissible trash-icon background:
          // blurred solid container with the icon centered.
          if (_dragOffset.abs() > 4)
            Positioned.fill(
              child: ClipPath(
                clipper: _SwipeClipper(_dragOffset),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    // Green background, icon on the side being revealed by the drag
                    // (same convention as queue Dismissible: swipe right → icon left,
                    //  swipe left → icon right)
                    color: const Color(0xFF1DB954).withValues(alpha: 0.15 * progress),
                    alignment: _dragOffset > 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Icon(
                      LucideIcons.listMusic,
                      color: const Color(0xFF1DB954).withValues(alpha: progress),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

          // ── The tile itself, translated horizontally ──
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: SongTile(
              song: widget.song,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              trailing: widget.trailing,
              isPlaying: widget.isPlaying,
              showDuration: widget.showDuration,
              index: widget.index,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeClipper extends CustomClipper<Path> {
  final double offset;
  _SwipeClipper(this.offset);

  @override
  Path getClip(Size size) {
    if (offset > 0) {
      return Path()..addRect(Rect.fromLTWH(0, 0, offset, size.height));
    } else {
      return Path()
        ..addRect(
            Rect.fromLTWH(size.width + offset, 0, -offset, size.height));
    }
  }

  @override
  bool shouldReclip(_SwipeClipper oldClipper) => offset != oldClipper.offset;
}
