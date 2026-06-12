import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_audio/just_audio.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/audio_provider.dart';
import 'services/audio_handler.dart';
import 'package:permission_handler/permission_handler.dart';

/// Global key for showing snackbars from anywhere (e.g. Providers)
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize audio_service for background playback + lock screen controls.
  // This creates the Android foreground service / iOS audio session.
  PulseAudioHandler? audioHandler;
  try {
    audioHandler = await initAudioService();
  } catch (e) {
    // If AudioService fails (e.g. missing AudioServiceActivity),
    // create a standalone handler so the app still launches.
    debugPrint('[Pulse] AudioService.init failed: $e');
    audioHandler = PulseAudioHandler(AudioPlayer());
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

class _PulseAppState extends ConsumerState<PulseApp> {
  bool _audioInitialized = false;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    // Watch auth state — gates the UI until auth resolves
    final auth = ref.watch(authProvider);

    // Watch accent color from settings
    final settings = ref.watch(settingsProvider);
    final accentColor = settings.accentColor;

    // Trigger initial settings load from disk on auth
    ref.listen(authProvider, (prev, next) {
      // Nothing needed here — settings load from disk automatically on startup.
    });

    // Show loading while Firebase auth resolves
    if (auth.loading) {
      return MaterialApp(
        key: const ValueKey('loading-app'),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(accentColor: accentColor),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(accentColor: accentColor),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

