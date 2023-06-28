import 'dart:io';
import 'package:easy/utils/notification.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

var id = 0;

class NotificationService {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late InitializationSettings initializationSettings;
  static BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationStream = BehaviorSubject();

  static init() async {
    await _configureLocalTimeZone();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await _requireIOSPermission();
    }

    await _initializedPlatform();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  static _requireIOSPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  static _initializedPlatform() async {
    var initAndroidSetting = const AndroidInitializationSettings('icon');
    var initIOSSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        didReceiveLocalNotificationStream.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      },
    );

    initializationSettings = InitializationSettings(
        android: initAndroidSetting, iOS: initIOSSetting);
  }

  static Future<void> showNotificationWithNoTitle() async {
    var scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    var notificationDetails = const NotificationDetails();
    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'scheduled title',
        'scheduled body', scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static showNotification({required String title, required String body}) async {
    var notificationDetails = const NotificationDetails();
    flutterLocalNotificationsPlugin.show(
        id++, title, body, notificationDetails);
  }

  static showRepeatEveryWorkingDays({
    required int id,
    required String androidChannelId,
    required String androidChannelName,
    String? title,
    String? body,
    String? channelDescription,
    int hour = 0,
    int minute = 0,
    int second = 0,
    bool forceNextDay = false,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextWorkingDay(
          hour: hour,
          minute: minute,
          second: second,
          forceNextDay: forceNextDay,
        ),
        NotificationDetails(
          android: AndroidNotificationDetails(
              androidChannelId, androidChannelName,
              channelDescription: channelDescription),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static _nextWorkingDay({
    int hour = 0,
    int minute = 0,
    int second = 0,
    bool forceNextDay = false,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute, second);
    if (forceNextDay) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    while (scheduledDate.weekday == DateTime.sunday ||
        scheduledDate.weekday == DateTime.saturday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  static loadAllNotification({
    bool forceNextDay = false,
    String channelName = "",
  }) async {
    scheduledNotifications
        .where((element) => channelName == ""
            ? true
            : element.androidChannelName == channelName)
        .forEach((notification) async {
      await showRepeatEveryWorkingDays(
        id: notification.id,
        androidChannelId: notification.androidChannelId,
        androidChannelName: notification.androidChannelName,
        title: notification.title,
        body: notification.body,
        hour: notification.hour,
        minute: notification.minute,
        forceNextDay: forceNextDay,
      );
    });
  }

  static cancelNotifications(String channelName) async {
    scheduledNotifications
        .where((element) => element.androidChannelName == channelName)
        .forEach((element) async {
      await flutterLocalNotificationsPlugin.cancel(element.id);
      await loadAllNotification(forceNextDay: true, channelName: channelName);
    });
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
