import 'dart:async';

import 'package:dio/dio.dart';

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

class DeviceRepository {
  late Dio dio;
  String baseUrl = "https://taspen-easy.vercel.app/api/";

  DeviceRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "secret-key": "F25BE3E73F6559C4",
    }));
  }

  Future<AuthResponse> login(
      {required String username,
      required String uuid,
      required String password}) async {
    try {
      var response = await dio.post("auth", data: {
        "username": username,
        "password": password,
        "uuid": uuid,
      });

      if (response.statusCode != 200) {
        return AuthResponse(
            status: false, message: response.statusMessage ?? '');
      }

      if (response.data['status'] == false) {
        return AuthResponse(status: false, message: response.data['message']);
      }

      var data = response.data['data'];

      return AuthResponse(
          status: true,
          username: username,
          fullname: data['fullname'],
          active: data['active'],
          token: data['token'] ?? "",
          ba: data['ba'] ?? "",
          nik: data['nik'] ?? "",
          jabatan: data['jabatan'] ?? "",
          unitKerja: data['unit_kerja'] ?? "",
          gender: data['gender'] ?? "");
    } on DioError catch (e) {
      return AuthResponse(status: false, message: e.response?.data["message"]);
    } catch (e) {
      return AuthResponse(status: false, message: "Up's something went wrong!");
    }
  }
}
