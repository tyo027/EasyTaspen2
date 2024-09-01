import 'package:easy/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class Messanging {
  static bool _hasInit = false;

  static initialize() async {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<String?> getToken() async {
    try {
      if (!_hasInit) {
        await initialize();
      }
      return FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
