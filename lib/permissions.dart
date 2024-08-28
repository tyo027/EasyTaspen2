import 'package:permission_handler/permission_handler.dart';

requestPermissions() async {
  final permissions = [
    Permission.camera,
    Permission.location,
    Permission.notification,
    Permission.scheduleExactAlarm,
  ];

  await permissions.request();
}
