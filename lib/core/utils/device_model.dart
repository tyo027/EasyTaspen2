import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceModel {
  final String name;
  final String appVersion;
  final String osVersion;

  DeviceModel({
    required this.name,
    required this.appVersion,
    required this.osVersion,
  });
}

Future<DeviceModel> getDeviceModel() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return DeviceModel(
      name: androidInfo.model,
      osVersion: androidInfo.version.release,
      appVersion: packageInfo.version,
    );
  }

  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

  return DeviceModel(
    name: iosInfo.utsname.machine.iOSProductName,
    osVersion: iosInfo.systemVersion,
    appVersion: packageInfo.version,
  );
}
