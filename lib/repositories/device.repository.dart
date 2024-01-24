// ignore_for_file: unnecessary_brace_in_string_interps, avoid_init_to_null

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
  final String? perty;
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
      this.perty = "",
      this.gender = ""});
}

class DeviceRepository extends Repository {
  setToken(
      {required String username,
      required String uuid,
      required String fcmToken,
      required String nik,
      String? token = null}) async {
    if (token != null) dio.options.headers["Authorization"] = "Bearer ${token}";

    var device = await getDevice();

    var response = await dio.post("absensi/1.0/DeviceId", data: {
      "username": username,
      "uuid": uuid,
      "fcm_token": fcmToken,
      "nik": nik,
      "device_name": device.device_name,
      "app_version": device.app_version,
      "os_version": device.os_version,
    });

    return response;
  }

  Future<DeviceIdModel> getDevice() async {
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

    return DeviceIdModel(
        device_name: deviceModel,
        app_version: version,
        os_version: deviceRelease);
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

      var fcmToken = await FcmService.getToken();

      var response = await setToken(
          username: username,
          uuid: uuid,
          fcmToken: fcmToken ?? "",
          nik: userData.user.nik,
          token: userData.token);

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
        perty: userData.user.perty,
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
