// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDr0OJN-8VoyLbSc-xgWUrSBWqI87WnHc4',
    appId: '1:333982810572:web:a17b8e99e0170dda655d69',
    messagingSenderId: '333982810572',
    projectId: 'servicenest-e84a5',
    authDomain: 'servicenest-e84a5.firebaseapp.com',
    storageBucket: 'servicenest-e84a5.appspot.com',
    measurementId: 'G-2E34GTJ4HJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClGh9lrLms_MJZwevDP06le6wdBojJFVY',
    appId: '1:333982810572:android:f8d1bc102a07cc2e655d69',
    messagingSenderId: '333982810572',
    projectId: 'servicenest-e84a5',
    storageBucket: 'servicenest-e84a5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYmwxN50bDP-xAaYniXup1gnDtuQAD5Rs',
    appId: '1:333982810572:ios:6f0a9d941a5dfa0d655d69',
    messagingSenderId: '333982810572',
    projectId: 'servicenest-e84a5',
    storageBucket: 'servicenest-e84a5.appspot.com',
    iosBundleId: 'com.example.serviceNest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYmwxN50bDP-xAaYniXup1gnDtuQAD5Rs',
    appId: '1:333982810572:ios:6f0a9d941a5dfa0d655d69',
    messagingSenderId: '333982810572',
    projectId: 'servicenest-e84a5',
    storageBucket: 'servicenest-e84a5.appspot.com',
    iosBundleId: 'com.example.serviceNest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDr0OJN-8VoyLbSc-xgWUrSBWqI87WnHc4',
    appId: '1:333982810572:web:db4c7bdc38bf86d7655d69',
    messagingSenderId: '333982810572',
    projectId: 'servicenest-e84a5',
    authDomain: 'servicenest-e84a5.firebaseapp.com',
    storageBucket: 'servicenest-e84a5.appspot.com',
    measurementId: 'G-J1F4LV7BK4',
  );
}