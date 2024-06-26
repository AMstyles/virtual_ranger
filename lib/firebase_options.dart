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
    apiKey: 'AIzaSyBH5lvj0oKmCEhJfbI4_NoRqFk1VCRYl9s',
    appId: '1:734421281531:android:8d33a2d09b628e6cf55e5e',
    messagingSenderId: '734421281531',
    projectId: 'virtualranger',
    storageBucket: 'virtualranger.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoeC_6rnuHngvPccCgnOH37-V8ZYsh7Cg',
    appId: '1:734421281531:ios:94ca1bd1dfdfe567f55e5e',
    messagingSenderId: '734421281531',
    projectId: 'virtualranger',
    storageBucket: 'virtualranger.appspot.com',
    androidClientId: '734421281531-2dd6amf1sbmug7lhra7rn7gcjv2gjqin.apps.googleusercontent.com',
    iosClientId: '734421281531-4lgf1qn576dm1g4stufvrbff917amjre.apps.googleusercontent.com',
    iosBundleId: 'com.example.virtualRanger',
  );
}
