// Bu dosya FlutterFire CLI tarafından otomatik oluşturulmuştur.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase uygulamanız için varsayılan [FirebaseOptions] ayarları.
///
/// Örnek kullanım:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  // Şu anki platforma uygun Firebase ayarlarını döndürür
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
          'Linux için Firebase ayarları yapılandırılmamış. FlutterFire CLI ile tekrar yapılandırabilirsiniz.',
        );
      default:
        throw UnsupportedError(
          'Bu platform için Firebase ayarları desteklenmiyor.',
        );
    }
  }

  // Web platformu için Firebase ayarları
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFJaZeAdYOHJm-aAbKjWAP_ABU0OGNFC8',
    appId: '1:485417259709:web:aa59110cd325d4cc9d1dd4',
    messagingSenderId: '485417259709',
    projectId: 'mobiluygulamagelistirme-d5e34',
    authDomain: 'mobiluygulamagelistirme-d5e34.firebaseapp.com',
    storageBucket: 'mobiluygulamagelistirme-d5e34.firebasestorage.app',
  );

  // Android platformu için Firebase ayarları
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhOWRYfYjL-pe1lCHAa7Poy8lxRwbqYFc',
    appId: '1:485417259709:android:fea0a811e4d47a549d1dd4',
    messagingSenderId: '485417259709',
    projectId: 'mobiluygulamagelistirme-d5e34',
    storageBucket: 'mobiluygulamagelistirme-d5e34.firebasestorage.app',
  );

  // iOS platformu için Firebase ayarları
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkMss6pr-3n269LfFU0btF2hg9DmcHErE',
    appId: '1:485417259709:ios:12834a2fc4edb1749d1dd4',
    messagingSenderId: '485417259709',
    projectId: 'mobiluygulamagelistirme-d5e34',
    storageBucket: 'mobiluygulamagelistirme-d5e34.firebasestorage.app',
    iosBundleId: 'com.example.mobiluygulamagelistirme',
  );

  // macOS platformu için Firebase ayarları
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkMss6pr-3n269LfFU0btF2hg9DmcHErE',
    appId: '1:485417259709:ios:12834a2fc4edb1749d1dd4',
    messagingSenderId: '485417259709',
    projectId: 'mobiluygulamagelistirme-d5e34',
    storageBucket: 'mobiluygulamagelistirme-d5e34.firebasestorage.app',
    iosBundleId: 'com.example.mobiluygulamagelistirme',
  );

  // Windows platformu için Firebase ayarları
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDFJaZeAdYOHJm-aAbKjWAP_ABU0OGNFC8',
    appId: '1:485417259709:web:1e21220b30b8b1849d1dd4',
    messagingSenderId: '485417259709',
    projectId: 'mobiluygulamagelistirme-d5e34',
    authDomain: 'mobiluygulamagelistirme-d5e34.firebaseapp.com',
    storageBucket: 'mobiluygulamagelistirme-d5e34.firebasestorage.app',
  );
}
