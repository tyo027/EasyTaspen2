import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:easy/services/storage.service.dart';
import 'package:easy/utils/notification.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmService {
  static init() async {
    await Alarm.init();
    await checkPermission();
    await _configureLocalTimeZone();
  }

  static checkPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.scheduleExactAlarm.status;
      print('Schedule exact alarm permission: $status.');
      if (status.isDenied) {
        print('Requesting schedule exact alarm permission...');
        final res = await Permission.scheduleExactAlarm.request();
        print(
            'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
      }

      status = await Permission.notification.status;
      if (status.isDenied) {
        alarmPrint('Requesting notification permission...');
        final res = await Permission.notification.request();
        alarmPrint(
          'Notification permission ${res.isGranted ? '' : 'not '}granted',
        );
      }
    }
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
    var increment = (now.weekday == 5) ? 30 : 0;

    scheduledNotifications
        .where((element) => element.androidChannelName == channelName)
        .forEach((element) async {
      var id0 = tz.TZDateTime(tz.local, now.year, now.month, now.day,
          element.hour, element.minute - increment);
      int id = id0.millisecondsSinceEpoch ~/ 10000;

      print('cancel notification $id');
      await Alarm.stop(id);
    });

    await loadAllNotification(
        channelName: channelName, weekday: now.weekday, forceNextDay: true);
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
        final alarmSettings = AlarmSettings(
          id: id0,
          dateTime: datetime,
          assetAudioPath: 'assets/audio/alarm.mp3',
          vibrate: false,
          loopAudio: false,
          notificationTitle: title ?? '',
          notificationBody: body ?? '',
          enableNotificationOnKill: Platform.isIOS,
          androidFullScreenIntent: false,
        );

        await Alarm.set(alarmSettings: alarmSettings);
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
}
