import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '378442523993', // Cari "Web API Key" di atas screenshot tadi
    appId:
        '1:378442523993:android:884f86b7908172c827d848', // Sudah aku isi sesuai gambarmu
    messagingSenderId: '378442523993', // Ini angka depan dari App ID kamu
    projectId: 'luxe-jewel-app',
    storageBucket: 'luxe-jewel-app.appspot.com',
  );
}
