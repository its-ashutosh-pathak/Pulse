import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUDMSkKB-_hL9bl45P5BxVEVXDrS7C4_8',
    appId: '1:360258546308:android:e3165370da4c53000af0d1',
    messagingSenderId: '360258546308',
    projectId: 'pulse-by-ap',
    storageBucket: 'pulse-by-ap.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1Q5wcGaPftt_2bzozPWy5hxAC8GGriwE',
    appId: '1:360258546308:ios:17ac5c852b7395250af0d1',
    messagingSenderId: '360258546308',
    projectId: 'pulse-by-ap',
    storageBucket: 'pulse-by-ap.firebasestorage.app',
    iosBundleId: 'com.ashutosh.pulse',
  );
}
