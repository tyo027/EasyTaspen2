import 'package:dio/dio.dart';
import 'package:easy/services/storage.service.dart';

class Repository {
  late Dio dio;
  String baseUrl = "https://api.taspen.co.id/ApiWebTaspen/public/api/";

  Repository() {
    var hasToken = Storage.has("token");

    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization":
          hasToken ? "Bearer ${Storage.read<String>('token')}" : null
    }));
  }

  setJWTToken(String token) {
    Storage.write("token", token);
    dio.options.headers['Authorization'] = "Bearer $token";
  }

  resetJWTToken() {
    dio.options.headers['Authorization'] = null;
  }
}
