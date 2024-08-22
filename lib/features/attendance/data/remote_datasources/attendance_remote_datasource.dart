import 'dart:convert';
import 'dart:io';

import 'package:easy/core/constants/api.dart';
import 'package:easy/features/attendance/data/models/attendance_model.dart';
import 'package:easy/features/attendance/data/models/attendance_recap_model.dart';
import 'package:easy/features/attendance/data/models/daily_attendance_model.dart';
import 'package:easy/features/attendance/data/models/mpp_model.dart';
import 'package:easy/features/attendance/data/models/rule_model.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:fca/fca.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract interface class AttendanceRemoteDatasource {
  Future<RuleModel> getRule(String codeCabang);

  Future<MppModel> getMpp(String nik);

  Future<void> submitAttendance({
    required String nik,
    required String kodeCabang,
    required double latitude,
    required double longitude,
    required AttendanceType type,
    required File file,
  });

  Future<List<AttendanceModel>> getDailyAttendance({
    required String nik,
  });

  Future<List<AttendanceRecapModel>> getAttendaceRecap({
    required String nik,
    required String startDate,
    required String finishDate,
  });

  Future<List<DailyAttendanceModel>> getAttendaceDailyRecap({
    required String nik,
    required String startDate,
    required String finishDate,
  });
}

class AttendanceRemoteDatasourceImpl implements AttendanceRemoteDatasource {
  InterceptedClient client;

  AttendanceRemoteDatasourceImpl(this.client);

  @override
  Future<RuleModel> getRule(String codeCabang) async {
    try {
      final response = await client.post(
        Uri.parse("${Api.rule}/$codeCabang"),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return RuleModel.fromJson(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MppModel> getMpp(String nik) async {
    try {
      final response = await client.post(
        Uri.parse(Api.mpp),
        body: jsonEncode(
          {"nik": nik},
        ),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return MppModel.fromJson(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> submitAttendance({
    required String nik,
    required String kodeCabang,
    required double latitude,
    required double longitude,
    required AttendanceType type,
    required File file,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Api.submitAttendance));

      request.fields.addAll({
        "nik": nik,
        "kdcabang": kodeCabang,
        "lat": latitude.toString(),
        "long": longitude.toString(),
        "keterangan": type.name.toUpperCase(),
        "work_from": (type == AttendanceType.wfo ? 1 : 2).toString(),
      });

      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', fileStream, length,
          contentType: MediaType('image', 'png'));

      request.files.add(multipartFile);

      var response = await request.send();

      var body = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw ResponseException(body);
      }
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AttendanceModel>> getDailyAttendance({
    required String nik,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("${Api.dailyAttendance}/$nik"),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return AttendanceModel.fromJsonList(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AttendanceRecapModel>> getAttendaceRecap({
    required String nik,
    required String startDate,
    required String finishDate,
  }) async {
    try {
      final response = await client.post(Uri.parse(Api.attendanceRecap),
          body: jsonEncode({
            "nik": nik,
            "tgl_mulai": startDate,
            "tgl_akhir": finishDate,
          }));

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return AttendanceRecapModel.fromJsonList(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DailyAttendanceModel>> getAttendaceDailyRecap({
    required String nik,
    required String startDate,
    required String finishDate,
  }) async {
    try {
      final response = await client.post(Uri.parse(Api.dailyRecap),
          body: jsonEncode({
            "nik": nik,
            "tgl_mulai": startDate,
            "tgl_akhir": finishDate,
          }));

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return DailyAttendanceModel.fromJsonList(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
