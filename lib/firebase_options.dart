// File generated manually based on google-services.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const String _apiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'REPLACE_ME');

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _apiKey,
    authDomain: "game-edukasi-80f11.firebaseapp.com",
    projectId: "game-edukasi-80f11",
    storageBucket: "game-edukasi-80f11.firebasestorage.app",
    messagingSenderId: "521444207194",
    appId: "1:521444207194:web:8822a5e5236bdaa6058663",
    measurementId: "G-HRSE54X090",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:521444207194:android:a57ad930de7dbb94058663',
    messagingSenderId: '521444207194',
    projectId: 'game-edukasi-80f11',
    storageBucket: 'game-edukasi-80f11.firebasestorage.app',
  );
}
