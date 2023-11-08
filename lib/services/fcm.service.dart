import 'package:easy/repositories/device.repository.dart';
import 'package:easy/services/notification.service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static bool _hasInit = false;
  static initialize() async {
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

    FirebaseMessaging.onMessage.listen(showNotification);
    FirebaseMessaging.onBackgroundMessage(showNotification);

    _hasInit = true;
  }

  static Future<void> showNotification(RemoteMessage message) async {
    if (message.notification != null) {
      NotificationService.showNotification(
          title: message.notification?.title ?? "-",
          body: message.notification?.body ?? '-');
    }
  }

  static Future<String?> getToken() async {
    if (!_hasInit) {
      await initialize();
    }
    return FirebaseMessaging.instance.getToken();
  }

  static Future<void> whenTokenUpdated(
      String username, String uuid, String nik) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
      await DeviceRepository().setToken(
        username: username,
        uuid: uuid,
        fcmToken: event,
        nik: nik
      );
    });
  }
}
