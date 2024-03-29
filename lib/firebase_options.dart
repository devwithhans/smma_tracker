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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyC_XAN6NXnQuXnu0XcvkMx00j9fCN2foOk',
    appId: '1:913647369249:web:a7ce629dd47e0982e5f760',
    messagingSenderId: '913647369249',
    projectId: 'bb-time-tracker',
    authDomain: 'bb-time-tracker.firebaseapp.com',
    storageBucket: 'bb-time-tracker.appspot.com',
    measurementId: 'G-G64K52KWKK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsb_gX0caEiptQ7X-LZZ5_JqWHEDGBnSI',
    appId: '1:913647369249:android:e68b5d6c5c07fdf3e5f760',
    messagingSenderId: '913647369249',
    projectId: 'bb-time-tracker',
    storageBucket: 'bb-time-tracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIyWrKU3ISO3TVmci-hRfWcYMxGKAT_po',
    appId: '1:913647369249:ios:cf1a5ad36b3caffae5f760',
    messagingSenderId: '913647369249',
    projectId: 'bb-time-tracker',
    storageBucket: 'bb-time-tracker.appspot.com',
    iosClientId: '913647369249-ugq3t48vs31uf4s4clgt33arg6eo7sr5.apps.googleusercontent.com',
    iosBundleId: 'dk.brunogboge.agencytime',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIyWrKU3ISO3TVmci-hRfWcYMxGKAT_po',
    appId: '1:913647369249:ios:a08069c867ccbd0de5f760',
    messagingSenderId: '913647369249',
    projectId: 'bb-time-tracker',
    storageBucket: 'bb-time-tracker.appspot.com',
    iosClientId: '913647369249-b9g0di8v2gfg6rbl0697h6cl6ld9ehla.apps.googleusercontent.com',
    iosBundleId: 'com.example.agencyTime',
  );
}
