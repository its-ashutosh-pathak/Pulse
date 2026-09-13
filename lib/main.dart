import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:media_kit/media_kit.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/audio_provider.dart';
import 'services/audio_handler.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pulse/src/rust/frb_generated.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pulse/l10n/generated/app_localizations.dart';
import 'package:pulse/core/utils/error_mapper.dart';
import 'l10n/fallback_localizations.dart';

/// Global key for showing snackbars from anywhere (e.g. Providers)
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Global navigator key for showing overlay toasts from anywhere
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await RustLib.init();
  } catch (e) {
    debugPrint('RustLib init failed: $e');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize media_kit
  MediaKit.ensureInitialized();

  // Initialize audio_service for background playback + lock screen controls.
  // This creates the Android foreground service / iOS audio session.
  PulseAudioHandler? audioHandler;
  
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    // Skip audio_service entirely on desktop platforms as it doesn't support them.
    // media_kit handles MPRIS/media keys natively on desktop.
    final fallbackPlayer = Player(configuration: const PlayerConfiguration(bufferSize: 4194304));
    audioHandler = PulseAudioHandler(fallbackPlayer);
  } else {
    try {
      audioHandler = await initAudioService();
    } catch (e) {
      // If AudioService fails (e.g. missing AudioServiceActivity),
      // create a standalone handler so the app still launches.
      debugPrint('[Pulse] AudioService.init failed: $e');
      final fallbackPlayer = Player(configuration: const PlayerConfiguration(bufferSize: 4194304));
      audioHandler = PulseAudioHandler(fallbackPlayer);
    }
  }

  // Immersive dark status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        // Inject the initialized audio handler so providers can access it.
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const PulseApp(),
    ),
  );
}

class PulseApp extends ConsumerStatefulWidget {
  const PulseApp({super.key});

  @override
  ConsumerState<PulseApp> createState() => _PulseAppState();
}

class _PulseAppState extends ConsumerState<PulseApp> with WidgetsBindingObserver {
  bool _audioInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize the audio engine with the audio handler singleton.
    // Using addPostFrameCallback to ensure ProviderScope is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_audioInitialized) {
        final handler = ref.read(audioHandlerProvider);
        ref.read(audioProvider.notifier).initialize(handler);
        _audioInitialized = true;

        // Request notification permission for Android 13+ lock screen / media controls
        // Safely done here so it doesn't block background headless launches
        Permission.notification.request();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only track when user actively opens the app, not when they minimize it
    if (state == AppLifecycleState.resumed) {
      ref.read(authProvider.notifier).updateLastActive();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state — gates the UI until auth resolves
    final auth = ref.watch(authProvider);

    // Watch accent color from settings
    final settings = ref.watch(settingsProvider);
    final accentColor = settings.accentColor;




    // Show loading while Firebase auth resolves
    if (auth.loading) {
      return MaterialApp(
        key: const ValueKey('loading-app'),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FallbackMaterialLocalizationDelegate(),
          FallbackCupertinoLocalizationDelegate(),
          FallbackWidgetsLocalizationDelegate(),
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: settings.appLocale == null ? null : Locale(settings.appLocale!),
        theme: AppTheme.dark(accentColor: accentColor),
        scrollBehavior: AppScrollBehavior(),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
        FallbackWidgetsLocalizationDelegate(),
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.appLocale == null ? null : Locale(settings.appLocale!),
      theme: AppTheme.dark(accentColor: accentColor),
      localeResolutionCallback: (locale, supportedLocales) {
        final resolved = supportedLocales.firstWhere(
          (s) => s.languageCode == locale?.languageCode,
          orElse: () => const Locale('en'),
        );
        ErrorMapper.setLocale(resolved);
        return resolved;
      },
      routerConfig: ref.watch(routerProvider),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
