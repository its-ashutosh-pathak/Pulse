import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Animated playing bars — port of .playing-bars CSS from index.css.
/// Shows the classic "equalizer bars" animation over a song thumbnail.
class PlayingBars extends StatefulWidget {
  final Color? color;
  final double height;
  final bool isPaused;

  const PlayingBars({super.key, this.color, this.height = 16, this.isPaused = false});

  @override
  State<PlayingBars> createState() => _PlayingBarsState();
}

class _PlayingBarsState extends State<PlayingBars>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  static const _barCount = 3;
  static const _delays = [0.0, 0.15, 0.3]; // Matches CSS animation-delay
  late final List<double> _currentPeaks;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_barCount, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
      );
    });

    _currentPeaks = [0.6, 1.0, 0.7]; // Initial peaks

    // Start each bar with its specific delay
    for (int i = 0; i < _barCount; i++) {
      _controllers[i].addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          // Generate a new random peak when the bar hits the bottom
          // Range from 0.1 (barely moves) to 1.0 (max height) for extreme visual randomness
          _currentPeaks[i] = 0.1 + (_random.nextDouble() * 0.9);
        }
      });

      Future.delayed(Duration(milliseconds: (_delays[i] * 1000).toInt()), () {
        if (mounted && !widget.isPaused) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void didUpdateWidget(PlayingBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        for (final c in _controllers) {
          c.stop();
        }
      } else {
        for (final c in _controllers) {
          c.repeat(reverse: true);
        }
      }
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
    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_barCount, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) {
              final scale = 0.2 + (CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOutCubic).value * 0.8 * _currentPeaks[i]);
              return Container(
                width: 3,
                height: widget.height,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                child: Transform.scale(
                  scaleY: scale,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    ));
  }
}
