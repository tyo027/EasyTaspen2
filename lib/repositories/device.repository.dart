import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy/models/deviceid.model.dart';
import 'package:easy/repositories/authentication.repository.dart';
import 'package:easy/repositories/repository.dart';
import 'package:easy/services/fcm.service.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthResponse {
  final bool status;
  final String message;
  final bool active;
  final String username;
  final String fullname;
  final String token;
  final String ba;
  final String nik;
  final String jabatan;
  final String unitKerja;
  final String gender;

  AuthResponse(
      {required this.status,
      this.message = "",
      this.active = false,
      this.username = "",
      this.fullname = "",
      this.token = "",
      this.ba = "",
      this.nik = "-",
      this.jabatan = "-",
      this.unitKerja = "",
      this.gender = ""});
}

class DeviceRepository extends Repository {
  Future<bool> setToken(
      {required String username,
      required String uuid,
      required String fcmToken,
      required String nik,
      required String deviceModel,
      required String version,
      required String deviceRelease}) async {
    var response = await dio.post("v2/DeviceId", data: {
      "username": username,
      "uuid": uuid,
      "fcm_token": fcmToken,
      "nik": nik,
      "device_name": deviceModel,
      "app_version": version,
      "os_version": deviceRelease,
    });

    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  Future<DeviceIdModel?> getDevice() async {
    String deviceModel = "";
    String deviceRelease = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      deviceRelease = androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine.iOSProductName;
      deviceRelease = iosInfo.systemVersion;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
  }

  Future<AuthResponse> login(
      {required String username,
      required String uuid,
      required String password}) async {
    try {
      var userData = await AuthenticationRepository().login(username, password);

      if (userData == null) {
        return AuthResponse(
            status: false, message: 'Username Atau Password Salah');
      }
      dio.options.headers["Authorization"] = "Bearer ${userData.token}";
      var fcmToken = await FcmService.getToken();

      var response = await dio.post("v2/DeviceId", data: {
        "username": username,
        "uuid": uuid,
        "fcm_token": fcmToken ?? "",
        "nik": userData.user.nik,
        "device_name": deviceModel ?? "",
        "app_version": version ?? "",
        "os_version": deviceRelease ?? "",
      });

      if (response.statusCode != 200) {
        return AuthResponse(
            status: false, message: response.statusMessage ?? '');
      }
      // print(response.data);
      // return AuthResponse(status: false);

      if (response.data['status'] == false) {
        return AuthResponse(status: false, message: response.data['message']);
      }

      return AuthResponse(
        status: true,
        username: username,
        fullname: userData.user.nama,
        active: true,
        token: userData.token,
        ba: userData.user.ba,
        nik: userData.user.nik,
        jabatan: userData.user.jabatan,
        unitKerja: userData.user.unitkerja,
        gender: userData.user.gender,
      );
    } on DioException catch (e) {
      return AuthResponse(
          status: false,
          message: e.response?.data['message'] ?? e.message.toString());
    } catch (e) {
      return AuthResponse(status: false, message: "Up's something went wrong!");
    }
  }
}
