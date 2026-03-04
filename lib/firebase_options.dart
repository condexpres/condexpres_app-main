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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIi_RDtCgAH2y-Lm8pps61GIbFRUBFbqQ',
    appId: '1:146442443540:android:66d2939a924e16fe490001',
    messagingSenderId: '146442443540',
    projectId: 'condexpres-banco-de-dados',
    databaseURL: 'https://condexpres-banco-de-dados-default-rtdb.firebaseio.com',
    storageBucket: 'condexpres-banco-de-dados.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBeJeDKJd55ML3_4xoESaw6vAsxwlK0lR4',
    appId: '1:146442443540:web:0d6e003cfa2ca4a5490001',
    messagingSenderId: '146442443540',
    projectId: 'condexpres-banco-de-dados',
    authDomain: 'condexpres-banco-de-dados.firebaseapp.com',
    databaseURL: 'https://condexpres-banco-de-dados-default-rtdb.firebaseio.com',
    storageBucket: 'condexpres-banco-de-dados.firebasestorage.app',
    measurementId: 'G-FS10ZJ2X1T',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-VGAahd09yMu1cN0HhdxVAYBHnIauhvI',
    appId: '1:146442443540:ios:49d72ecdca7a6d36490001',
    messagingSenderId: '146442443540',
    projectId: 'condexpres-banco-de-dados',
    databaseURL: 'https://condexpres-banco-de-dados-default-rtdb.firebaseio.com',
    storageBucket: 'condexpres-banco-de-dados.firebasestorage.app',
    androidClientId: '146442443540-v1pql8o476p1809jmceq4eepv10r7ov5.apps.googleusercontent.com',
    iosClientId: '146442443540-c82mehlin6ba78ub5md44n8mluv6a5gn.apps.googleusercontent.com',
    iosBundleId: 'com.example.condexpressMain',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-VGAahd09yMu1cN0HhdxVAYBHnIauhvI',
    appId: '1:146442443540:ios:49d72ecdca7a6d36490001',
    messagingSenderId: '146442443540',
    projectId: 'condexpres-banco-de-dados',
    databaseURL: 'https://condexpres-banco-de-dados-default-rtdb.firebaseio.com',
    storageBucket: 'condexpres-banco-de-dados.firebasestorage.app',
    androidClientId: '146442443540-v1pql8o476p1809jmceq4eepv10r7ov5.apps.googleusercontent.com',
    iosClientId: '146442443540-c82mehlin6ba78ub5md44n8mluv6a5gn.apps.googleusercontent.com',
    iosBundleId: 'com.example.condexpressMain',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeJeDKJd55ML3_4xoESaw6vAsxwlK0lR4',
    appId: '1:146442443540:web:57c32bdb2fa2ae9d490001',
    messagingSenderId: '146442443540',
    projectId: 'condexpres-banco-de-dados',
    authDomain: 'condexpres-banco-de-dados.firebaseapp.com',
    databaseURL: 'https://condexpres-banco-de-dados-default-rtdb.firebaseio.com',
    storageBucket: 'condexpres-banco-de-dados.firebasestorage.app',
    measurementId: 'G-40HDJHC6VH',
  );

}