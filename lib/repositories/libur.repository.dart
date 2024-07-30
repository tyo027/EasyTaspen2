import 'package:dio/dio.dart';

class LiburRepository {
  late Dio dio;
  String baseUrl =
      "https://api.taspen.co.id/ApiWebTaspen/public/api/v2/GetTanggalMerah";

  LiburRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjkwNTAsImlzcyI6Imh0dHA6Ly9hcGkudGFzcGVuLmNvLmlkL0FwaVdlYlRhc3Blbi9wdWJsaWMvYXBpL3VzZXIvbG9naW4iLCJpYXQiOjE3MDMyNjAxMzYsImV4cCI6MTczNDc5NjEzNiwibmJmIjoxNzAzMjYwMTM2LCJqdGkiOiJGR3RPeVdycEw4MWIzQ29IIn0.BKHh-4wlAnVsXDOwonArCW7IIdVoHdkrjnXa-G5nl-Y"
    }));
  }

  Future<bool> getIsLibur({required String tgl_merah}) async {
    try {
      var response = await dio.post("", data: {
        "tgl_merah": tgl_merah,
      });
      //print(response.data);
      return response.data['data']['status'];
    } catch (e) {
      return false;
    }
  }
}
