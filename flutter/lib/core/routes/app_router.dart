import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/library/library_screen.dart';
import '../../screens/player/player_screen.dart';
import '../../screens/playlist/playlist_screen.dart';
import '../../screens/artist/artist_screen.dart';
import '../../screens/downloads/downloads_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/import/import_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../widgets/app_scaffold.dart';

/// Global navigator keys for shell route nesting.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configuration — mirrors React Router config from App.jsx.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ── Login (no shell) ──
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // ── Full-screen player (no bottom nav) ──
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/player',
      builder: (context, state) => const PlayerScreen(),
    ),

    // ── Main shell (with bottom nav + mini player) ──
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LibraryScreen(),
          ),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/downloads',
          builder: (context, state) => const DownloadsScreen(),
        ),
        GoRoute(
          path: '/playlist/:id',
          builder: (context, state) =>
              PlaylistScreen(playlistId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/artist/:id',
          builder: (context, state) =>
              ArtistScreen(browseId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/import',
          builder: (context, state) => const ImportScreen(),
        ),
      ],
    ),
  ],
);
