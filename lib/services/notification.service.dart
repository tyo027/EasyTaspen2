import 'dart:io';
import 'package:easy/repositories/libur.repository.dart';
import 'package:easy/services/storage.service.dart';
import 'package:easy/utils/notification.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

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
    } else {
      var result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestFullScreenIntentPermission();

      print("Result $result");
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

    var id0 = tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month,
        scheduledDate.day, scheduledDate.hour, scheduledDate.minute);
    int id = id0.millisecondsSinceEpoch ~/ 10000;
    var notificationDetails = const NotificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'scheduled title',
        'scheduled body', scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static showNotification({required String title, required String body}) async {
    var scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    var id0 = tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month,
        scheduledDate.day, scheduledDate.hour, scheduledDate.minute);
    int id = id0.millisecondsSinceEpoch ~/ 10000;
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'easy.notification.id', 'easy.notification.channel',
            channelDescription: 'Easy notification',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker');
    var notificationDetails =
        const NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  static Future<int> showRepeatEveryWorkingDays(
      {required int id,
      required String androidChannelId,
      required String androidChannelName,
      String? title,
      String? body,
      String? channelDescription,
      int hour = 0,
      int minute = 0,
      int second = 0,
      bool forceNextDay = false,
      int? weekday}) async {
    var workingDays = weekday ?? 5;

    int? lastId;
    var lastLoadedNotification = Storage.read("lastNotificationId");
    var lastAbsen = Storage.read('last-absen');

    for (var weekdays = weekday ?? 1; weekdays <= workingDays; weekdays++) {
      var datetime = _zonedDay(
          hour: hour,
          minute: weekdays == 5 ? minute - 30 : minute,
          second: second,
          forceNextDay: forceNextDay,
          weekday: weekdays);

      int id0 = datetime.millisecondsSinceEpoch ~/ 10000;

      if (lastAbsen != null) {
        var lastWorkingDay = DateTime.fromMillisecondsSinceEpoch(lastAbsen);

        if (lastWorkingDay.day == datetime.day &&
            lastWorkingDay.month == datetime.month &&
            lastWorkingDay.year == datetime.year) {
          if (lastWorkingDay.hour < 12 &&
              androidChannelName == "NOTIF_MASUK_KERJA") {
            continue;
          }
          if (lastWorkingDay.hour >= 12 &&
              androidChannelName == "NOTIF_PULANG_KERJA") {
            continue;
          }
        }
      }
      //print("$lastLoadedNotification \t $id0");
      if (lastLoadedNotification == null ||
          (lastLoadedNotification != null && id0 > lastLoadedNotification)) {
        print('Load notif $id0 $datetime ');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id0,
          title,
          body,
          datetime,
          NotificationDetails(
            android: AndroidNotificationDetails(
                androidChannelId, androidChannelName,
                channelDescription: channelDescription),
          ),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          // matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
        );
      }
      if (lastId == null || (id0 > lastId)) {
        lastId = id0;
      }
    }
    return lastId!;
  }

  static tz.TZDateTime _zonedDay(
      {int hour = 0,
      int minute = 0,
      int second = 0,
      bool forceNextDay = false,
      int? weekday}) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute, second);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (forceNextDay) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (weekday != null) {
      while (scheduledDate.weekday != weekday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      return scheduledDate;
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

  static loadAllNotification(
      {bool forceNextDay = false,
      String channelName = "",
      int? weekday}) async {
    var notificationIds = [];
    print(tz.local);
    for (var notification in scheduledNotifications.where((element) =>
        channelName == "" ? true : element.androidChannelName == channelName)) {
      var lastId = await showRepeatEveryWorkingDays(
          id: notification.id,
          androidChannelId: notification.androidChannelId,
          androidChannelName: notification.androidChannelName,
          title: notification.title,
          body: notification.body,
          hour: notification.hour,
          minute: notification.minute,
          forceNextDay: forceNextDay,
          weekday: weekday);
      notificationIds.add(lastId);
    }

    notificationIds.sort((a, b) => a < b ? 0 : 1);
    print(notificationIds);
    Storage.write("lastNotificationId", notificationIds.last);
  }

  static cancelNotifications(String channelName) async {
    final now = tz.TZDateTime.now(tz.local);

    // tz.TZDateTime scheduledDate =
    //     tz.TZDateTime(tz.local, now.year, now.month, now.day);
    var increment = (now.weekday == 5) ? 30 : 0;

    scheduledNotifications
        .where((element) => element.androidChannelName == channelName)
        .forEach((element) async {
      var id0 = tz.TZDateTime(tz.local, now.year, now.month, now.day,
          element.hour, element.minute - increment);
      int id = id0.millisecondsSinceEpoch ~/ 10000;

      print('cancel notification $id');
      await flutterLocalNotificationsPlugin.cancel(id);
    });

    // if (await LiburRepository().getIsLibur(
    //     tgl_merah: DateFormat("yyyy-MM-dd").format(
    //         tz.TZDateTime(tz.local, now.year, now.month, now.day + 7)))) {
    //   return;
    // }

    await loadAllNotification(
        channelName: channelName, weekday: now.weekday, forceNextDay: true);
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
