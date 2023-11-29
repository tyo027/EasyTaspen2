class Notification {
  int id;
  String androidChannelId;
  String androidChannelName;
  String title;
  String body;
  int hour;
  int minute;

  Notification({
    required this.id,
    required this.androidChannelId,
    required this.androidChannelName,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
  });
}

var now = DateTime.now();

var scheduledNotifications = [
  Notification(
    id: 1,
    androidChannelId: "NOTIF_MASUK_KERJA_1",
    androidChannelName: "NOTIF_MASUK_KERJA",
    title: "Sudah saatnya masuk kerja",
    body: "Jangan lupa absen masuk ya",
    hour: 07,
    minute: 45,
  ),
  Notification(
    id: 2,
    androidChannelId: "NOTIF_MASUK_KERJA_2",
    androidChannelName: "NOTIF_MASUK_KERJA",
    title: "Sudah saatnya masuk kerja",
    body: "Jangan lupa absen masuk ya",
    hour: 07,
    minute: 50,
  ),
  Notification(
    id: 3,
    androidChannelId: "NOTIF_MASUK_KERJA_3",
    androidChannelName: "NOTIF_MASUK_KERJA",
    title: "Sudah saatnya masuk kerja",
    body: "Jangan lupa absen masuk ya",
    hour: 07,
    minute: 55,
  ),
  Notification(
    id: 4,
    androidChannelId: "NOTIF_PULANG_KERJA_1",
    androidChannelName: "NOTIF_PULANG_KERJA",
    title: "Sudah saatnya pulang kerja",
    body: "Jangan lupa absen pulang ya",
    hour: 17,
    minute: 00,
  ),
  Notification(
    id: 5,
    androidChannelId: "NOTIF_PULANG_KERJA_2",
    androidChannelName: "NOTIF_PULANG_KERJA",
    title: "Sudah saatnya pulang kerja",
    body: "Jangan lupa absen pulang ya",
    hour: 17,
    minute: 15,
  ),
  Notification(
    id: 6,
    androidChannelId: "NOTIF_PULANG_KERJA_3",
    androidChannelName: "NOTIF_PULANG_KERJA",
    title: "Sudah saatnya pulang kerja",
    body: "Jangan lupa absen pulang ya",
    hour: 18,
    minute: 00,
  )
];
