import 'dart:io';
import 'package:easy/features/notification/data/models/notification_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract interface class NotificationDatasource {
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  });

  Future<void> scheduleAllDailyNotifications();

  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotification();
  Future<void> rescheduleNotification({
    required List<NotificationModel> notifications,
    required int weekday,
  });
}

class NotificationDatasourceImpl implements NotificationDatasource {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  bool initialized = false;

  NotificationDatasourceImpl(this._notificationsPlugin) {
    initialize();
  }

  Future<void> initialize() async {
    await _configureLocalTimeZone();

    if (Platform.isIOS) {
      await _requireIOSPermission();
    } else if (Platform.isAndroid) {
      await _requireAndroidPermission();
    }

    const androidInitializationSettings = AndroidInitializationSettings('icon');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) => {},
    );
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    initialized = true;
  }

  _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  Future<void> _requireIOSPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _requireAndroidPermission() async {}

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!initialized) await initialize();

    _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> scheduleAllDailyNotifications() async {
    await _notificationsPlugin.cancelAll();

    for (var notification in NotificationModel.allNotifications()) {
      for (var i = 1; i <= 5; i++) {
        final id = i * 10000 + notification.id;
        final dateTime =
            _nextInstanceOfTime(time: notification.timeOfDay, weekday: i);

        if (kDebugMode) {
          print('ID $id \t Date $dateTime');
        }

        await _schedule(
          id: id,
          title: notification.title,
          message: notification.message,
          dateTime: dateTime,
        );
      }
    }
  }

  tz.TZDateTime _nextInstanceOfTime({
    required TimeOfDay time,
    required int weekday,
    bool forceNextWeek = false,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      weekday == DateTime.friday ? time.minute - 30 : time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (forceNextWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 5));
    }

    while (scheduledDate.weekday != weekday ||
        scheduledDate.weekday >= DateTime.saturday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  NotificationDetails notificationDetails() {
    const androidNotificationDetail = AndroidNotificationDetails(
      'EASY_DAILY_ATTENDANCE_NOTIFICATION',
      'Easy Daily Attendance',
      channelDescription: 'Reminders to submit daily attendance',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Attendance Reminder',
      playSound: true,
      enableVibration: true,
      enableLights: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const iosNotificationDetail = DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetail,
      iOS: iosNotificationDetail,
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  @override
  Future<void> rescheduleNotification({
    required List<NotificationModel> notifications,
    required int weekday,
  }) async {
    if ([DateTime.saturday, DateTime.sunday].contains(weekday)) return;

    for (var notification in notifications) {
      final id = weekday * 10000 + notification.id;

      await cancelNotification(id);

      final dateTime = _nextInstanceOfTime(
        time: notification.timeOfDay,
        weekday: weekday,
        forceNextWeek: true,
      );

      if (kDebugMode) {
        print('ID $id \t Date $dateTime');
      }

      await _schedule(
        id: id,
        title: notification.title,
        message: notification.message,
        dateTime: dateTime,
      );
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String message,
    required tz.TZDateTime dateTime,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      message,
      dateTime,
      notificationDetails(),
      // Requires SCHEDULE_EXACT_ALARM permission
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelAllNotification() async {
    await _notificationsPlugin.cancelAll();
  }
}
