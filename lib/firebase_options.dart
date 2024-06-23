/**
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
    throw UnsupportedError(
    'DefaultFirebaseOptions have not been configured for android - '
    'you can reconfigure this by running the FlutterFire CLI again.',
    );
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
    apiKey: 'AIzaSyBaPLxjjVdHmjQe_Nnt5B5tj_AqC2PvUvw',
    appId: '1:404053653773:web:92a69d7b6536d7c4169844',
    messagingSenderId: '404053653773',
    projectId: 'io-hackathon',
    authDomain: 'io-hackathon.firebaseapp.com',
    storageBucket: 'io-hackathon.appspot.com',
    measurementId: 'G-DWB3CG9EEG',
    );

    static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaQrghF1803BK50Xdz7-_dbwLS199cn_s',
    appId: '1:404053653773:ios:f98c4b18babce711169844',
    messagingSenderId: '404053653773',
    projectId: 'io-hackathon',
    storageBucket: 'io-hackathon.appspot.com',
    iosBundleId: 'com.funalex.player',
    );

    static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaQrghF1803BK50Xdz7-_dbwLS199cn_s',
    appId: '1:404053653773:ios:b9da01c61d3c24d9169844',
    messagingSenderId: '404053653773',
    projectId: 'io-hackathon',
    storageBucket: 'io-hackathon.appspot.com',
    iosBundleId: 'com.funalex.player.RunnerTests',
    );
    }
