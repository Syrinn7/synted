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
    apiKey: 'AIzaSyBguoz2sjD3y16dI_S9IYvaPQTRjBoLYK8',
    appId: '1:631638776463:web:a14826b68062a4c26faefa',
    messagingSenderId: '631638776463',
    projectId: 'tpdevmobileatouo',
    authDomain: 'tpdevmobileatouo.firebaseapp.com',
    storageBucket: 'tpdevmobileatouo.appspot.com',
    measurementId: 'G-DQQHRS017M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASmdhkXLoV2xtdxtc9oH-9wAc6OAvVRcE',
    appId: '1:631638776463:android:c22c9a2405c65d756faefa',
    messagingSenderId: '631638776463',
    projectId: 'tpdevmobileatouo',
    storageBucket: 'tpdevmobileatouo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-hfuuvF7zch4sFa-BvUpqjE4sCLdNosY',
    appId: '1:631638776463:ios:06386463992d98dc6faefa',
    messagingSenderId: '631638776463',
    projectId: 'tpdevmobileatouo',
    storageBucket: 'tpdevmobileatouo.appspot.com',
    iosBundleId: 'com.example.vintedSyrine',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-hfuuvF7zch4sFa-BvUpqjE4sCLdNosY',
    appId: '1:631638776463:ios:06386463992d98dc6faefa',
    messagingSenderId: '631638776463',
    projectId: 'tpdevmobileatouo',
    storageBucket: 'tpdevmobileatouo.appspot.com',
    iosBundleId: 'com.example.vintedSyrine',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBguoz2sjD3y16dI_S9IYvaPQTRjBoLYK8',
    appId: '1:631638776463:web:c49a4568d24592316faefa',
    messagingSenderId: '631638776463',
    projectId: 'tpdevmobileatouo',
    authDomain: 'tpdevmobileatouo.firebaseapp.com',
    storageBucket: 'tpdevmobileatouo.appspot.com',
    measurementId: 'G-DG3X4ZNFWE',
  );
}
