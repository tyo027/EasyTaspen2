import 'package:easy/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class Messanging {
  static bool _hasInit = false;

  static initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _hasInit = true;
  }

  static Future<String?> getToken() async {
    if (!_hasInit) {
      await initialize();
    }
    return FirebaseMessaging.instance.getToken();
  }

  static Future<void> whenTokenUpdated(
      String username, String uuid, String nik) async {
    // FirebaseMessaging.instance.onTokenRefresh.listen((event) async {});
  }
}
