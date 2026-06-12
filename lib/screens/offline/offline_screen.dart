import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/theme/app_colors.dart';

/// Offline screen — port of OfflineScreen.jsx.
/// Shows animated glowing rings around Pulse logo, retry button, and go to downloads.
class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    setState(() => _isChecking = true);
    final result = await Connectivity().checkConnectivity();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final isOnline = result.any((r) => r != ConnectivityResult.none);
    setState(() => _isChecking = false);

    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Still offline. Please check your connection.', style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    // If online, ConnectivityWrapper will automatically swap back to the main content
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Animated Pulse Logo ──
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 200, height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rings
                          for (int i = 0; i < 3; i++)
                            Builder(
                              builder: (context) {
                                final offset = i / 3;
                                final progress = (_pulseController.value + offset) % 1.0;
                                final scale = 1.0 + progress; // from 1.0 to 2.0
                                final opacity = 1.0 - progress; // from 1.0 to 0.0
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 100, height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: accent.withValues(alpha: opacity * 0.6), 
                                        width: 2
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                          // Logo
                          Image.asset('assets/logo.png', width: 90, height: 90, fit: BoxFit.contain),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ── WiFi Off Icon ──
                Icon(LucideIcons.wifiOff, size: 48, color: accent),
                const SizedBox(height: 20),

                // ── Title ──
                const Text("You're Offline",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text(
                  'No internet connection found.\nCheck your network and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textSecondary,
                      height: 1.5),
                ),

                const SizedBox(height: 32),

                // ── Retry Button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _retry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: _isChecking
                        ? SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(AppColors.background),
                            ),
                          )
                        : const Icon(LucideIcons.refreshCw, size: 18),
                    label: Text(_isChecking ? 'Checking...' : 'Retry'),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Go to Downloads ──
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/downloads'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.glassBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(LucideIcons.download, size: 18),
                    label: const Text('Go to Downloads'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
