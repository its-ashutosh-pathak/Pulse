import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_colors.dart';
import '../screens/offline/offline_screen.dart';
import 'mini_player.dart';
import '../providers/update_provider.dart';
import '../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App scaffold — the persistent shell with bottom nav + mini player.
/// Equivalent to Layout.jsx in the React app.
/// Includes a connectivity monitor that swaps to OfflineScreen when offline.
class AppScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  bool _isOffline = false;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySub;

  @override
  void initState() {
    super.initState();

    // Check initial connectivity
    Connectivity().checkConnectivity().then((result) {
      if (mounted) {
        setState(() => _isOffline = result.isEmpty || !result.any((r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet));
      }
    });

    // Listen for connectivity changes
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() => _isOffline = result.isEmpty || !result.any((r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet));
      }
    });

    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        ref.read(unreadBadgeTimeProvider.notifier).state = prefs.getInt('lastOpenedSupportTime') ?? 0;
      }
    });

    // Schedule update check after first frame so context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final updateState = ref.read(updateNotifierProvider);
      if (updateState.value?.isUpdateAvailable == true) {
        // Already resolved — show dialog immediately
        _showUpdateDialog(updateState.value!);
      } else {
        // Still loading — listen for when it resolves
        ProviderSubscription? sub;
        sub = ref.listenManual<AsyncValue<AppUpdateInfo?>>(
          updateNotifierProvider,
          (previous, next) {
            if (next.value?.isUpdateAvailable == true) {
              sub?.close();
              _showUpdateDialog(next.value!);
            }
          },
        );
      }
    });
  }

  void _showUpdateDialog(AppUpdateInfo info) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xCC0A0A0A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Update Available',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Version ${info.latestVersion} is here! Update now to get the latest features.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Centered button — wraps its own content
                    ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(info.downloadUrl),
                            mode: LaunchMode.externalApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.defaultAccentCyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Download Update',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    super.dispose();
  }

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

    final location = GoRouterState.of(context).uri.toString();
    // Show offline screen when no connectivity, unless on offline-capable pages
    final isOfflinePlaylist = location.startsWith('/playlist/__pl__') ||
        location.startsWith('/playlist/__downloads__');
    if (_isOffline && !location.startsWith('/downloads') && !isOfflinePlaylist) {
      return const OfflineScreen();
    }

    final auth = ref.watch(authProvider);
    final photoURL = auth.photoURL;
    final initials = auth.initials;
    
    Widget? profileIcon;
    if (auth.isLoggedIn) {
      if (photoURL != null && photoURL.startsWith('assets/')) {
        profileIcon = Container(
          width: 26, height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: currentIndex == 4 ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
            image: DecorationImage(image: AssetImage(photoURL), fit: BoxFit.cover),
          ),
        );
      } else {
        profileIcon = Container(
          width: 26, height: 26,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: currentIndex == 4 ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
          ),
          child: Center(
            child: Text(initials, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          ),
        );
      }
    }

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Mini Player ──
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 22,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: const MiniPlayer(),
            ),
          ),

          // ── Bottom Navigation ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF000000),
                  Color(0xF5000000),
                  Color(0xE0000000),
                  Color(0x80000000),
                  Color(0x00000000),
                ],
                stops: [0.0, 0.25, 0.5, 0.8, 1.0],
              ),

            ),
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
                      customIcon: profileIcon != null ? _ProfileBadge(child: profileIcon) : null,
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
  final Widget? customIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    this.customIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Theme.of(context).colorScheme.primary : Colors.white;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customIcon ?? Icon(icon, size: 22, color: color),
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

class _ProfileBadge extends ConsumerWidget {
  final Widget child;
  const _ProfileBadge({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    if (user == null) return child;

    final badgeTime = ref.watch(unreadBadgeTimeProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (auth.isAdmin)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('support_channels').where('unreadByAdmin', isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return Positioned(
                right: -4, top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  child: Text('$count', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              );
            },
          )
        else
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('support_messages')
                .where(Filter.or(
                  Filter('userId', isEqualTo: user.uid),
                  Filter('isAnnouncement', isEqualTo: true)
                ))
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              int count = 0;
              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final time = (data['timestamp'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                final isMe = data['senderId'] == user.uid;
                if (!isMe && time > badgeTime) {
                  count++;
                }
              }
              if (count == 0) return const SizedBox.shrink();
              return Positioned(
                right: -4, top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  child: Text(count > 9 ? '9+' : '$count', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              );
            },
          )
      ],
    );
  }
}
