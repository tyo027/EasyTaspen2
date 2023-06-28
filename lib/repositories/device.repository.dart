import 'package:dio/dio.dart';

class DeviceRepository {
  late Dio dio;
  String baseUrl = "https://taspen-easy.vercel.app/api/";

  DeviceRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "secret-key": "F25BE3E73F6559C4",
    }));
  }

  Future<bool> checkLogin(
      {required String username, required String uuid}) async {
    try {
      await dio.post("absen", data: {
        "username": username,
        "uuid": uuid,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
