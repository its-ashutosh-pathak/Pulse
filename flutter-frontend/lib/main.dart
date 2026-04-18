import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/audio_provider.dart';
import 'services/audio_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize audio_service for background playback + lock screen controls.
  // This creates the Android foreground service / iOS audio session.
  final audioHandler = await initAudioService();

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

    // Load backend settings once authenticated
    ref.listen(authProvider, (prev, next) {
      if (prev?.isLoggedIn != true && next.isLoggedIn) {
        ref.read(settingsProvider.notifier).loadFromBackend();
      }
    });

    // Show loading while Firebase auth resolves
    if (auth.loading) {
      return MaterialApp(
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
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(accentColor: accentColor),
      routerConfig: appRouter,
    );
  }
}
