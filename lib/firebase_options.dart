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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'This platform is not supported by DefaultFirebaseOptions yet.',
        );
    }
  }

  // ANDROID (هذا أهم شي لأنك على محاكي أندرويد)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9oyZ0sLJGgrco2JOjB97jU9AUcXGffkM',
    appId: '1:11839404171:android:13f3c7d77024abe0ae3c8e',
    messagingSenderId: '11839404171',
    projectId: 'ccodey-34e51',
    storageBucket: 'ccodey-34e51.firebasestorage.app',
  );

  // دول الباقي ما نستخدمهم حاليا بس لازم موجودين حتى ما يصرخ الكود
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9oyZ0sLJGgrco2JOjB97jU9AUcXGffkM',
    appId: '1:11839404171:web:13f3c7d77024abe0ae3c8e',
    messagingSenderId: '11839404171',
    projectId: 'ccodey-34e51',
    storageBucket: 'ccodey-34e51.firebasestorage.app',
    authDomain: 'ccodey-34e51.firebaseapp.com',
    measurementId: '',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9oyZ0sLJGgrco2JOjB97jU9AUcXGffkM',
    appId: '1:11839404171:ios:13f3c7d77024abe0ae3c8e',
    messagingSenderId: '11839404171',
    projectId: 'ccodey-34e51',
    storageBucket: 'ccodey-34e51.firebasestorage.app',
    iosClientId: '',
    iosBundleId: '',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9oyZ0sLJGgrco2JOjB97jU9AUcXGffkM',
    appId: '1:11839404171:ios:13f3c7d77024abe0ae3c8e',
    messagingSenderId: '11839404171',
    projectId: 'ccodey-34e51',
    storageBucket: 'ccodey-34e51.firebasestorage.app',
    iosClientId: '',
    iosBundleId: '',
  );
}
