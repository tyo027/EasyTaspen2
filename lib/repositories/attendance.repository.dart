import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy/models/attendance.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/repository.dart';
import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceRepository extends Repository {
  Future<bool> submit(
      {required UserModel user,
      required Position position,
      required SubmitAttendanceType type}) async {
    try {
      var data = FormData.fromMap({
        "nik": user.nik,
        "kdcabang": user.ba,
        "lat": position.latitude,
        "long": position.longitude,
        "keterangan": type.name,
        "work_from": type == SubmitAttendanceType.wfo ? 1 : 2,
        "file": await MultipartFile.fromFile(await assetPath(),
            filename: "black.jpeg"),
      });

      await dio.post("v2/SubmitAbsen", data: data);
      return true;
      // print(response);
      // return AuthenticationModel.fromJson(response.data);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> assetPath() async {
    final byteData = await rootBundle.load('assets/images/black.jpeg');
    final buffer = byteData.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        '$tempPath/file_01.tmp'; // file_01.tmp is dump file, can be anything
    await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return filePath;
  }

  Future<List<AttendanceModel>> getAttendances({required String nik}) async {
    try {
      var response = await dio.get("v2/GetAbsen/$nik");
      return attendanceModelFromJson(response.data);
    } catch (e) {
      return [];
    }
  }
}
