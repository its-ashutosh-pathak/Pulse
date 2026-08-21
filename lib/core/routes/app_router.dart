import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/library/playlists_screen.dart';
import '../../screens/player/player_screen.dart';
import '../../screens/playlist/playlist_screen.dart';
import '../../screens/artist/artist_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/import/import_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/communication/communication_screen.dart';
import '../../screens/communication/admin_chat_screen.dart';
import '../../screens/communication/broadcast_chat_screen.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/player_aware_pop_scope.dart';
import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

/// GoRouter configuration — mirrors React Router config from App.jsx.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      if (authState.loading) return null;

      final isLoggedIn = authState.isLoggedIn;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }

      return null;
    },
    routes: [
      // ── Login (no shell) ──
      GoRoute(
        name: 'Login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Full-screen player (no bottom nav) ──
      GoRoute(
        name: 'Player',
        parentNavigatorKey: navigatorKey,
        path: '/player',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const PlayerScreen(),
            transitionDuration: const Duration(milliseconds: 250),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return ScaleTransition(
                alignment: const Alignment(0.0, 0.85), // Aligns roughly with the mini player position above the nav bar
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                  reverseCurve: Curves.easeOutCubic,
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeIn,
                    reverseCurve: Curves.easeIn,
                  ),
                  child: child,
                ),
              );
            },
          );
        },
      ),

      // ── Communication & Support (no bottom nav) ──
      GoRoute(
        name: 'Communication',
        path: '/communication',
        builder: (context, state) => const CommunicationScreen(),
      ),
      GoRoute(
        name: 'BroadcastChat',
        path: '/communication/broadcast',
        builder: (context, state) => const BroadcastChatScreen(),
      ),
      GoRoute(
        name: 'AdminChat',
        path: '/communication/chat/:userId',
        builder: (context, state) => AdminChatScreen(
          userId: state.pathParameters['userId']!,
          userEmail: state.uri.queryParameters['email'] ?? '',
          userName: state.uri.queryParameters['name'] ?? '',
          userPhotoUrl: state.uri.queryParameters['photo'] ?? '',
        ),
      ),

      // ── Main shell (with bottom nav + mini player) ──
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Home',
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Library',
                path: '/library',
                builder: (context, state) => const PlaylistsScreen(),
              ),
              GoRoute(
                name: 'Downloads',
                path: '/downloads',
                builder: (context, state) => const PlaylistsScreen(initialTabIndex: 1),
              ),
              GoRoute(
                name: 'Downloading',
                path: '/downloading',
                builder: (context, state) => const PlaylistsScreen(initialTabIndex: 2),
              ),
              GoRoute(
                name: 'Playlist',
                path: '/playlist/:id',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: PlayerAwarePopScope(
                    child: PlaylistScreen(playlistId: state.pathParameters['id']!),
                  ),
                ),
              ),
              GoRoute(
                name: 'Artist',
                path: '/artist/:id',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: PlayerAwarePopScope(
                    child: ArtistScreen(browseId: state.pathParameters['id']!),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Search',
                path: '/search',
                builder: (context, state) => SearchScreen(initialQuery: state.uri.queryParameters['q']),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Settings',
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                name: 'Import',
                path: '/import',
                builder: (context, state) => const PlayerAwarePopScope(
                  child: ImportScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Profile',
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.listen(authProvider, (_, __) => router.refresh());
  return router;
});

