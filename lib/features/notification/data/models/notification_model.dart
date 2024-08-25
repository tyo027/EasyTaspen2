import 'package:easy/features/notification/domain/entities/notification.dart';
import 'package:flutter/material.dart' as m;

class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.timeOfDay,
  });

  static List<NotificationModel> morningNotification() {
    const title = "Sudah saatnya masuk kerja";
    const message = "Jangan lupa absen masuk ya";

    const List<m.TimeOfDay> times = [
      m.TimeOfDay(hour: 7, minute: 45),
      m.TimeOfDay(hour: 7, minute: 50),
      m.TimeOfDay(hour: 7, minute: 55),
    ];

    return times.map(
      (timeOfDay) {
        return NotificationModel(
          id: timeOfDay.hour * 100 + timeOfDay.minute,
          title: title,
          message: message,
          timeOfDay: timeOfDay,
        );
      },
    ).toList();
  }

  static List<NotificationModel> eveningNotification() {
    const title = "Sudah saatnya pulang kerja";
    const message = "Jangan lupa absen pulang ya";

    const List<m.TimeOfDay> times = [
      m.TimeOfDay(hour: 17, minute: 00),
      m.TimeOfDay(hour: 17, minute: 30),
      m.TimeOfDay(hour: 18, minute: 00),
    ];

    return times.map(
      (timeOfDay) {
        return NotificationModel(
          id: timeOfDay.hour * 100 + timeOfDay.minute,
          title: title,
          message: message,
          timeOfDay: timeOfDay,
        );
      },
    ).toList();
  }

  static List<NotificationModel> allNotifications() {
    return [...morningNotification(), ...eveningNotification()];
  }
}
