import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Animated playing bars — port of .playing-bars CSS from index.css.
/// Shows the classic "equalizer bars" animation over a song thumbnail.
class PlayingBars extends StatefulWidget {
  final Color? color;
  final double height;

  const PlayingBars({super.key, this.color, this.height = 16});

  @override
  State<PlayingBars> createState() => _PlayingBarsState();
}

class _PlayingBarsState extends State<PlayingBars>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  static const _barCount = 3;
  static const _delays = [0.0, 0.15, 0.3]; // Matches CSS animation-delay
  static const _heights = [0.6, 1.0, 0.7]; // Matches CSS height percentages

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_barCount, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
    });

    // Start each bar with its specific delay
    for (int i = 0; i < _barCount; i++) {
      Future.delayed(Duration(milliseconds: (_delays[i] * 1000).toInt()), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barColor = widget.color ?? AppColors.defaultAccentCyan;
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_barCount, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) {
              final scale = 0.5 + (_controllers[i].value * 0.5);
              return Container(
                width: 3,
                height: widget.height * _heights[i] * scale,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
