import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import 'glass_container.dart';
import 'mini_player.dart';

/// App scaffold — the persistent shell with bottom nav + mini player.
/// Equivalent to Layout.jsx in the React app.
class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  static int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/settings')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Mini Player ──
          const MiniPlayer(),

          // ── Bottom Navigation ──
          GlassContainer(
            borderRadius: 0,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: LucideIcons.home,
                      label: 'Home',
                      isActive: currentIndex == 0,
                      onTap: () => context.go('/'),
                    ),
                    _NavItem(
                      icon: LucideIcons.library,
                      label: 'Library',
                      isActive: currentIndex == 1,
                      onTap: () => context.go('/library'),
                    ),
                    _NavItem(
                      icon: LucideIcons.search,
                      label: 'Search',
                      isActive: currentIndex == 2,
                      onTap: () => context.go('/search'),
                    ),
                    _NavItem(
                      icon: LucideIcons.settings,
                      label: 'Settings',
                      isActive: currentIndex == 3,
                      onTap: () => context.go('/settings'),
                    ),
                    _NavItem(
                      icon: LucideIcons.user,
                      label: 'Profile',
                      isActive: currentIndex == 4,
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
