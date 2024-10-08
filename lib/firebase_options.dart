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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAJ3qxhJqueu9akdz11QtPZMLnstXPbBR4',
    appId: '1:812568091676:web:64ced53d2e82d7190393d9',
    messagingSenderId: '812568091676',
    projectId: 'zerowaste-8e1d8',
    authDomain: 'zerowaste-8e1d8.firebaseapp.com',
    storageBucket: 'zerowaste-8e1d8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAz2CGHaNBaDGCtcm7gZk3uFP29MbobIsM',
    appId: '1:812568091676:android:3f744c28df6af6ac0393d9',
    messagingSenderId: '812568091676',
    projectId: 'zerowaste-8e1d8',
    storageBucket: 'zerowaste-8e1d8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAa9CRqRYucvQPivie4sUCEAsJwGFJwQT0',
    appId: '1:812568091676:ios:1d42caa9a330df2e0393d9',
    messagingSenderId: '812568091676',
    projectId: 'zerowaste-8e1d8',
    storageBucket: 'zerowaste-8e1d8.appspot.com',
    iosBundleId: 'com.zerowaste.zeroWaste',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJ3qxhJqueu9akdz11QtPZMLnstXPbBR4',
    appId: '1:812568091676:web:286cf79ca922f2010393d9',
    messagingSenderId: '812568091676',
    projectId: 'zerowaste-8e1d8',
    authDomain: 'zerowaste-8e1d8.firebaseapp.com',
    storageBucket: 'zerowaste-8e1d8.appspot.com',
  );
}
