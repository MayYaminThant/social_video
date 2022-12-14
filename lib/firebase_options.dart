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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDraliIWZCgHl1F9sXja4bQitpjnWHhEWM',
    appId: '1:745490198344:android:a5e232bcdb7321ddaccd7d',
    messagingSenderId: '745490198344',
    projectId: 'social-video-project-two',
    databaseURL: 'https://social-video-project-two-default-rtdb.firebaseio.com',
    storageBucket: 'social-video-project-two.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0IFJbgYl7Q2T_1WWaDviZPkWm9qhkkuA',
    appId: '1:745490198344:ios:1523343220984ef4accd7d',
    messagingSenderId: '745490198344',
    projectId: 'social-video-project-two',
    databaseURL: 'https://social-video-project-two-default-rtdb.firebaseio.com',
    storageBucket: 'social-video-project-two.appspot.com',
    iosClientId: '745490198344-3bfqhmimagm7kt5s96ra631l6klv3a6i.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialVideo',
  );
}
