import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/sleep_timer_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../widgets/glass_container.dart';

class SleepTimerSheet extends ConsumerStatefulWidget {
  const SleepTimerSheet({super.key});

  @override
  ConsumerState<SleepTimerSheet> createState() => _SleepTimerSheetState();
}

class _SleepTimerSheetState extends ConsumerState<SleepTimerSheet> {
  Duration _selectedDuration = Duration.zero;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(sleepTimerProvider);
    final isActive = timerState.isActive;

    return GlassContainer(
      borderRadius: 24,
      blur: 24,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 420,
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sleep Timer',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          if (isActive)
                            Text(
                              'Running',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    
                    Expanded(
                      child: Center(
                        child: isActive 
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CircularProgressIndicator(
                                        value: timerState.totalDuration.inSeconds > 0 
                                            ? (timerState.remaining.inSeconds / timerState.totalDuration.inSeconds).clamp(0.0, 1.0)
                                            : 0.0,
                                        strokeWidth: 8,
                                        color: Theme.of(context).colorScheme.primary,
                                        backgroundColor: AppColors.surface,
                                        strokeCap: StrokeCap.round,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.bedtime, size: 32, color: Theme.of(context).colorScheme.primary),
                                          const SizedBox(height: 12),
                                          Text(
                                            _formatDuration(timerState.remaining),
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                              fontFeatures: [FontFeature.tabularFigures()],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'SLEEP',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ref.read(sleepTimerProvider.notifier).togglePause();
                                      },
                                      icon: Icon(timerState.isPaused ? Icons.play_arrow : Icons.pause, size: 32, color: AppColors.textPrimary),
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.surface,
                                        padding: const EdgeInsets.all(16),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    IconButton(
                                      onPressed: () {
                                        ref.read(sleepTimerProvider.notifier).cancelTimer();
                                      },
                                      icon: const Icon(Icons.stop, size: 32, color: AppColors.textPrimary),
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.surface,
                                        padding: const EdgeInsets.all(16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 32,
                                    margin: const EdgeInsets.symmetric(horizontal: 48),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        child: CupertinoPicker.builder(
                                          selectionOverlay: const SizedBox.shrink(),
                                          itemExtent: 32,
                                          childCount: 24,
                                          scrollController: FixedExtentScrollController(initialItem: _selectedDuration.inHours),
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              _selectedDuration = Duration(hours: value, minutes: _selectedDuration.inMinutes.remainder(60));
                                            });
                                          },
                                          itemBuilder: (context, index) => Center(
                                            child: Text(
                                              index.toString().padLeft(2, '0'), 
                                              style: TextStyle(
                                                fontSize: 22, 
                                                color: index == _selectedDuration.inHours ? Theme.of(context).colorScheme.primary : AppColors.textPrimary,
                                                fontWeight: index == _selectedDuration.inHours ? FontWeight.bold : FontWeight.normal,
                                              )
                                            )
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text('hours', style: TextStyle(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                                      const SizedBox(width: 32), // Pushes the minutes selector further to the right
                                      SizedBox(
                                        width: 45,
                                        child: CupertinoPicker.builder(
                                          selectionOverlay: const SizedBox.shrink(),
                                          itemExtent: 32,
                                          childCount: 60,
                                          scrollController: FixedExtentScrollController(initialItem: _selectedDuration.inMinutes.remainder(60)),
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              _selectedDuration = Duration(hours: _selectedDuration.inHours, minutes: value);
                                            });
                                          },
                                          itemBuilder: (context, index) => Center(
                                            child: Text(
                                              index.toString().padLeft(2, '0'), 
                                              style: TextStyle(
                                                fontSize: 22, 
                                                color: index == _selectedDuration.inMinutes.remainder(60) ? Theme.of(context).colorScheme.primary : AppColors.textPrimary,
                                                fontWeight: index == _selectedDuration.inMinutes.remainder(60) ? FontWeight.bold : FontWeight.normal,
                                              )
                                            )
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text('min.', style: TextStyle(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ),
                    
                    if (!isActive)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              if (_selectedDuration.inMinutes < 1) {
                                ToastUtils.show(context, 'Please select a valid sleep timer time');
                                return;
                              }
                              ref.read(sleepTimerProvider.notifier).startTimer(_selectedDuration);
                            },
                            child: const Text('Start Timer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
