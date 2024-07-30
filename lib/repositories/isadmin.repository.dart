import 'package:dio/dio.dart';

class IsAdminRepository {
  late Dio dio;
  String baseUrl =
      "https://api.taspen.co.id/ApiWebTaspen/public/api/v2/GetUserAdmin";

  IsAdminRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjkwNTAsImlzcyI6Imh0dHA6Ly9hcGkudGFzcGVuLmNvLmlkL0FwaVdlYlRhc3Blbi9wdWJsaWMvYXBpL3VzZXIvbG9naW4iLCJpYXQiOjE3MDMyNjAxMzYsImV4cCI6MTczNDc5NjEzNiwibmJmIjoxNzAzMjYwMTM2LCJqdGkiOiJGR3RPeVdycEw4MWIzQ29IIn0.BKHh-4wlAnVsXDOwonArCW7IIdVoHdkrjnXa-G5nl-Y"
    }));
  }

  Future<bool> getIsAdmin({required String nik}) async {
    try {
      var response = await dio.post("", data: {
        "nik": nik,
      });
      //print(response.data);
      return response.data['data']['status'];
    } catch (e) {
      return false;
    }
  }
}
