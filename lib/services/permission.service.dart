import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestPermission() async {
    var permissions = [
      Permission.camera,
      Permission.location,
      Permission.notification,
      Permission.scheduleExactAlarm,
    ];
    var hasDeniedPermission = false;
    await permissions.request();

    for (var element in permissions) {
      var status = await element.status;
      if (status.isPermanentlyDenied) {
        hasDeniedPermission = true;
      }
    }
    return !hasDeniedPermission;
  }
}
