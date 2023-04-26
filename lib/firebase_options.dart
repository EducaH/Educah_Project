// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBZa3ca5EBgsUuoBEJ-0cMmb9pr53v1eY4',
    appId: '1:263099780198:web:cbe185005de7309e0b31a7',
    messagingSenderId: '263099780198',
    projectId: 'educah-9994e',
    authDomain: 'educah-9994e.firebaseapp.com',
    storageBucket: 'educah-9994e.appspot.com',
    measurementId: 'G-W42Q4MVVM2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHmectNURo8TUOEUwg6QQFKAOXjPiLLnI',
    appId: '1:263099780198:android:816f7ef970dbe8230b31a7',
    messagingSenderId: '263099780198',
    projectId: 'educah-9994e',
    storageBucket: 'educah-9994e.appspot.com',
  );
}
