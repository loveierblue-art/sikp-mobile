import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByx7MxLV5giLxPF4rZKJKQRYkK1S3Gf_U',
    appId: '1:898657794548:web:e1dd82dd5ffd534b7421a1',
    messagingSenderId: '898657794548',
    projectId: 'sikp-app',
    authDomain: 'sikp-app.firebaseapp.com',
    storageBucket: 'sikp-app.firebasestorage.app',
    measurementId: 'G-6H2PJ6GF3Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBasnftO9BHmn2k6X1RhgKcwc6yNAmmyTk',
    appId: '1:898657794548:android:b09473ea1e127cb07421a1',
    messagingSenderId: '898657794548',
    projectId: 'sikp-app',
    storageBucket: 'sikp-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDdl4o6UaLMB0hdAG5MkKRNgc7MzKft15A',
    appId: '1:898657794548:ios:1638abc422ee14fd7421a1',
    messagingSenderId: '898657794548',
    projectId: 'sikp-app',
    storageBucket: 'sikp-app.firebasestorage.app',
    iosBundleId: 'com.example.sikpMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDdl4o6UaLMB0hdAG5MkKRNgc7MzKft15A',
    appId: '1:898657794548:ios:1638abc422ee14fd7421a1',
    messagingSenderId: '898657794548',
    projectId: 'sikp-app',
    storageBucket: 'sikp-app.firebasestorage.app',
    iosBundleId: 'com.example.sikpMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyByx7MxLV5giLxPF4rZKJKQRYkK1S3Gf_U',
    appId: '1:898657794548:web:e116b0d124a5dd107421a1',
    messagingSenderId: '898657794548',
    projectId: 'sikp-app',
    authDomain: 'sikp-app.firebaseapp.com',
    storageBucket: 'sikp-app.firebasestorage.app',
    measurementId: 'G-0Q8CNY9GYV',
  );
}
