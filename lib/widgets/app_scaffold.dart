import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../core/theme/app_colors.dart';
import '../screens/offline/offline_screen.dart';
import '../screens/player/player_screen.dart';
import 'mini_player.dart';
import 'desktop_scaffold.dart';
import 'package:flutter/foundation.dart';
import '../providers/update_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/player_overlay_provider.dart';
import '../providers/audio_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import '../providers/search_focus_provider.dart';

/// App scaffold — the persistent shell with bottom nav + mini player.
/// Equivalent to Layout.jsx in the React app.
/// Includes a connectivity monitor that swaps to OfflineScreen when offline.
class AppScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  bool _isOffline = false;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySub;

  final PanelController _panelController = PanelController();
  double _panelPosition = 0.0;

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
                    Text(
                      AppLocalizations.of(context)!.appUpdateAvailable,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.appUpdateDesc(info.latestVersion),
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
                      child: Text(
                        AppLocalizations.of(context)!.appUpdateDownload,
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

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    final location = GoRouterState.of(context).uri.toString();
    // Show offline screen when no connectivity, unless on offline-capable pages
    final isOfflinePlaylist = location.startsWith('/playlist/__pl__') ||
        location.startsWith('/playlist/__downloads__');
    final isDownloadsRoute = location.startsWith('/downloads');
        
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    if (!isDesktop && _isOffline && !isDownloadsRoute && !isOfflinePlaylist) {
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

    final showPlayer = ref.watch(playerOverlayProvider);

    ref.listen(playerOverlayProvider, (previous, next) {
      if (_panelController.isAttached) {
        if (next) {
          _panelController.open();
        } else {
          _panelController.close();
        }
      }
    });

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomNavHeight = 60.0 + bottomPadding;
    final miniPlayerHeight = 68.0;

    final hasCurrentSong = ref.watch(audioProvider.select((a) => a.currentSong != null));

    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return DesktopScaffold(navigationShell: widget.navigationShell);
    }

    final scaffold = Scaffold(
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: bottomNavHeight + (hasCurrentSong ? miniPlayerHeight : 0),
      ),
      body: widget.navigationShell,
    );

    // The bottom navigation bar widget
    final bottomNavWidget = Container(
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
                label: AppLocalizations.of(context)!.navHome,
                isActive: currentIndex == 0,
                onTap: () => widget.navigationShell.goBranch(0, initialLocation: currentIndex == 0),
              ),
              _NavItem(
                icon: LucideIcons.library,
                label: AppLocalizations.of(context)!.navLibrary,
                isActive: currentIndex == 1,
                onTap: () => widget.navigationShell.goBranch(1, initialLocation: currentIndex == 1),
              ),
              _NavItem(
                icon: LucideIcons.search,
                label: AppLocalizations.of(context)!.navSearch,
                isActive: currentIndex == 2,
                onTap: () {
                  if (currentIndex == 2) {
                    // Already on Search — request keyboard focus
                    ref.read(searchFocusRequestProvider.notifier).state = true;
                  } else {
                    widget.navigationShell.goBranch(2, initialLocation: false);
                  }
                },
              ),
              _NavItem(
                icon: LucideIcons.settings,
                label: AppLocalizations.of(context)!.navSettings,
                isActive: currentIndex == 3,
                onTap: () => widget.navigationShell.goBranch(3, initialLocation: currentIndex == 3),
              ),
              _NavItem(
                icon: LucideIcons.user,
                customIcon: profileIcon != null ? _ProfileBadge(child: profileIcon) : null,
                label: AppLocalizations.of(context)!.navProfile,
                isActive: currentIndex == 4,
                onTap: () => widget.navigationShell.goBranch(4, initialLocation: currentIndex == 4),
              ),
            ],
          ),
        ),
      ),
    );

    final isQueueOpen = ref.watch(playerQueueOpenProvider);

    return PopScope(
      canPop: !showPlayer,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(playerOverlayProvider.notifier).state = false;
        }
      },
      child: Stack(
        children: [
          // 1. SlidingUpPanel
          SlidingUpPanel(
            controller: _panelController,
            minHeight: hasCurrentSong ? (miniPlayerHeight + bottomNavHeight) : 0.0,
            maxHeight: MediaQuery.of(context).size.height,
            color: Colors.transparent, // Crucial for non-box look
            boxShadow: const [],
            isDraggable: hasCurrentSong && !isQueueOpen && _panelPosition < 1.0,
            onPanelSlide: (position) {
              setState(() {
                _panelPosition = position;
              });
            },
            onPanelClosed: () {
              if (ref.read(playerOverlayProvider)) {
                ref.read(playerOverlayProvider.notifier).state = false;
              }
            },
            onPanelOpened: () {
              if (!ref.read(playerOverlayProvider)) {
                ref.read(playerOverlayProvider.notifier).state = true;
              }
            },
            collapsed: !hasCurrentSong
                ? const SizedBox.shrink()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: const Material(
                            type: MaterialType.transparency,
                            child: MiniPlayer(),
                          ),
                        ),
                      ),
                      SizedBox(height: bottomNavHeight), // Space reserved for the real bottom nav
                    ],
                  ),
            panelBuilder: (sc) {
              return Opacity(
                opacity: _panelPosition,
                child: const PlayerScreen(),
              );
            },
            body: scaffold,
          ),

          // 2. Bottom Navigation Bar on top of the panel stack
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: _panelPosition > 0.0,
              child: Transform.translate(
                offset: Offset(0, _panelPosition * bottomNavHeight),
                child: Material(
                  type: MaterialType.transparency,
                  child: bottomNavWidget,
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

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                // Only fetch messages newer than the last time user opened chat.
                // Defaults to 7 days ago for new users.
                .where(
                  'timestamp',
                  isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(
                    badgeTime > 0
                        ? badgeTime
                        : DateTime.now()
                            .subtract(const Duration(days: 7))
                            .millisecondsSinceEpoch,
                  ),
                )
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              int count = 0;
              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final isMe = data['senderId'] == user.uid;
                if (!isMe) count++;
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

