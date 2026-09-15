import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/audio_provider.dart';
import '../screens/library/playlists_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/communication/communication_screen.dart';
import '../screens/communication/admin_chat_screen.dart';
import '../screens/communication/broadcast_chat_screen.dart';
import '../providers/desktop_layout_provider.dart';
import '../providers/search_provider.dart';
import '../core/routes/app_router.dart';
import 'mini_player.dart';
import 'search_dropdown_overlay.dart';

class DesktopScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const DesktopScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends ConsumerState<DesktopScaffold> {
  final TextEditingController _searchController = TextEditingController();

  GoRouter? _router;

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onRouteChanged() {
    final rightPaneState = ref.read(desktopRightPaneProvider);
    if (rightPaneState != DesktopRightPane.shell) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(desktopRightPaneProvider.notifier).state = DesktopRightPane.shell;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(routerProvider);
    if (_router != router) {
      _router?.routerDelegate.removeListener(_onRouteChanged);
      _router = router;
      _router?.routerDelegate.addListener(_onRouteChanged);
    }

    final hasSong = ref.watch(audioProvider.select((a) => a.currentSong != null));

    // Determine what to show in the right pane
    final rightPaneState = ref.watch(desktopRightPaneProvider);

    Widget rightPaneContent;
    switch (rightPaneState) {
      case DesktopRightPane.player:
        rightPaneContent = const PlayerScreen();
        break;
      case DesktopRightPane.communication:
        rightPaneContent = const CommunicationScreen();
        break;
      case DesktopRightPane.broadcastChat:
        rightPaneContent = const BroadcastChatScreen();
        break;
      case DesktopRightPane.adminChat:
        rightPaneContent = AdminChatScreen(
          userId: ref.watch(desktopChatUserIdProvider),
          userName: ref.watch(desktopChatUserNameProvider),
          userEmail: ref.watch(desktopChatUserEmailProvider),
          userPhotoUrl: ref.watch(desktopChatUserPhotoProvider),
        );
        break;
      case DesktopRightPane.shell:
        // If the shell is currently exactly on the Home screen ('/'),
        // show the Player on the right since Home is fixed to the center.
        // Otherwise (e.g. if a playlist is pushed onto the Home branch),
        // show the navigation shell so the pushed route is visible.
        final location = GoRouterState.of(context).uri.path;
        if (location == '/') {
          rightPaneContent = const PlayerScreen();
        } else {
          rightPaneContent = widget.navigationShell;
        }
        break;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // ── Unified Top App Bar ──
          _DesktopTopBar(
            navigationShell: widget.navigationShell,
            searchController: _searchController,
          ),

          // ── 3-Pane Content Area ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  // ── Left Pane: Library (Always visible) ──
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const PlaylistsScreen(initialTabIndex: 0),
                    ),
                  ),
                  ),
                  const SizedBox(width: 8),

                  // ── Center Pane: Main Content (Always Home) ──
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            // Main Content (Always Home)
                            ClipRect(child: const HomeScreen()),

                            // Floating Mini Player (only if playing)
                            if (hasSong)
                              Positioned(
                                bottom: 24,
                                left: 24,
                                right: 24,
                                child: Center(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 16,
                                          offset: const Offset(0, 8),
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
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ── Right Pane: Dynamic Content (Player or Routed Page) ──
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: rightPaneContent,
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopTopBar extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  final TextEditingController searchController;

  const _DesktopTopBar({
    required this.navigationShell,
    required this.searchController,
  });

  @override
  ConsumerState<_DesktopTopBar> createState() => _DesktopTopBarState();
}

class _DesktopTopBarState extends ConsumerState<_DesktopTopBar> {
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _searchLayerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();

  final GlobalKey _searchBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChanged);
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchFocusNode.dispose();
    widget.searchController.removeListener(_onSearchChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _onSearchChanged() {
    final query = widget.searchController.text.trim();
    ref.read(searchProvider.notifier).onQueryChanged(query);
  }

  void _showOverlay() {
    if (!_overlayController.isShowing) {
      _overlayController.show();
    }
  }

  void _removeOverlay() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {

    final auth = ref.watch(authProvider);
    final photoURL = auth.photoURL;
    final initials = auth.initials;

    final isSettingsActive =
        ref.watch(desktopRightPaneProvider) == DesktopRightPane.shell &&
        widget.navigationShell.currentIndex == 3;
    final isProfileActive =
        ref.watch(desktopRightPaneProvider) == DesktopRightPane.shell &&
        widget.navigationShell.currentIndex == 4;

    Widget? profileIcon;
    if (auth.isLoggedIn) {
      if (photoURL != null && photoURL.startsWith('assets/')) {
        profileIcon = Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isProfileActive
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
            image: DecorationImage(
              image: AssetImage(photoURL),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        profileIcon = Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            border: isProfileActive
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      }
    } else {
      profileIcon = Icon(
        LucideIcons.user,
        size: 28,
        color: isProfileActive
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
      );
    }

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: Colors.black),
      child: Row(
        children: [
          // ── Left: App Logo ──
          SizedBox(
            width: 416, // 440 (pane width) - 24 (padding)
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 43,
                    height: 43,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // ── Center: Search Bar ──
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 458),
                    child: TapRegion(
                      groupId: 'search',
                      onTapOutside: (_) {
                        _searchFocusNode.unfocus();
                        _removeOverlay();
                      },
                      child: CompositedTransformTarget(
                        link: _searchLayerLink,
                        child: OverlayPortal(
                          controller: _overlayController,
                          overlayChildBuilder: (context) {
                            double overlayWidth = 458;
                            if (_searchBarKey.currentContext != null) {
                              final box = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
                              overlayWidth = box.size.width;
                            }
                            return Positioned(
                              width: overlayWidth,
                              child: CompositedTransformFollower(
                                link: _searchLayerLink,
                                showWhenUnlinked: false,
                                offset: const Offset(0, 50),
                                child: TapRegion(
                                  groupId: 'search',
                                  child: SearchDropdownOverlay(
                                    onClose: () {
                                      _searchFocusNode.unfocus();
                                      _removeOverlay();
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            key: _searchBarKey,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  LucideIcons.search,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: widget.searchController,
                                    focusNode: _searchFocusNode,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Songs, artists, albums, playlists...',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onSubmitted: (val) {
                                      if (val.trim().isNotEmpty) {
                                        ref.read(searchProvider.notifier).hideSuggestions();
                                      }
                                    },
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
              ],
            ),
          ),

        // ── Right: Settings & Profile ──
        SizedBox(
            width: 416, // balance the left side
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    LucideIcons.settings,
                    size: 26,
                    color: isSettingsActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  ),
                  onPressed: () {
                    ref.read(desktopRightPaneProvider.notifier).state =
                        DesktopRightPane.shell;
                    widget.navigationShell.goBranch(3, initialLocation: true);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    ref.read(desktopRightPaneProvider.notifier).state =
                        DesktopRightPane.shell;
                    widget.navigationShell.goBranch(4, initialLocation: true);
                  },
                  child: profileIcon,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


