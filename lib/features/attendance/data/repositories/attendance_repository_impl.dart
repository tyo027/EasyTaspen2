import 'dart:io';

import 'package:easy/core/constants/constants.dart';
import 'package:easy/core/utils/location.dart';
import 'package:easy/features/attendance/data/remote_datasources/attendance_remote_datasource.dart';
import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:easy/features/attendance/domain/entities/attendance_recap.dart';
import 'package:easy/features/attendance/domain/entities/daily_attendance.dart';
import 'package:easy/features/attendance/domain/entities/my_location.dart';
import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDatasource attendanceRemoteDatasource;
  final ConnectionChecker connectionChecker;

  AttendanceRepositoryImpl(
    this.attendanceRemoteDatasource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Rule>> getRule({
    required String codeCabang,
    required String nik,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final rule = await attendanceRemoteDatasource.getRule(codeCabang);

      final mpp = await attendanceRemoteDatasource.getMpp(nik);

      if (mpp.isCustom) {
        return right(rule.copyWith(
          lat: mpp.lat,
          long: mpp.long,
          jarak: mpp.radius,
        ));
      }

      return right(rule);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, MyLocation>> getMyLocation({
    required bool allowMockLocation,
    required String kodeCabang,
    required String nik,
    required AttendanceType type,
    required int radius,
    required double centerLatitude,
    required double centerLongitude,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      late PositionResult location;

      if (nik == dotenv.env['DEVELOPER_NIK']) {
        location = HasPosition(
          position: Position(
            longitude: double.parse(dotenv.env["DEVELOPER_LON"] ?? '0'),
            latitude: double.parse(dotenv.env["DEVELOPER_LAT"] ?? '0'),
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 1,
            headingAccuracy: 1,
          ),
        );
      } else {
        location = await Location.getCurrentPosition(
          allowMockLocation: allowMockLocation,
        );
      }

      if (location is PositionNotFound) {
        return left(Failure("Position not found!"));
      }

      if (location is FakePosition) {
        return left(Failure("Fake GPS detected!"));
      }

      if (location is! HasPosition) {
        return left(Failure());
      }

      final address = await Location.getCurrentAddress(
        latitude: location.position.latitude,
        longitude: location.position.longitude,
      );

      final imageSrc = Location.getImageUrlRadius(
        latitude: location.position.latitude,
        longitude: location.position.longitude,
        centerLatitude: centerLatitude,
        centerLongitude: centerLongitude,
        radius: radius,
      );

      final distance = await Location.getDistanceTo(
        fromLatitude: location.position.latitude,
        fromLongitude: location.position.longitude,
        latitude: centerLatitude,
        longitude: centerLongitude,
      );

      return right(
        MyLocation(
          address: address,
          imageSrc: imageSrc,
          longitude: location.position.longitude,
          latitude: location.position.latitude,
          isInRange: radius >= distance,
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> submitAttendance({
    required String nik,
    required String kodeCabang,
    required double latitude,
    required double longitude,
    required AttendanceType type,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final file = await biometricFile();

      await attendanceRemoteDatasource.submitAttendance(
        file: file,
        nik: nik,
        latitude: latitude,
        longitude: longitude,
        kodeCabang: kodeCabang,
        type: type,
      );

      return right(true);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<File> biometricFile() async {
    final byteData = await rootBundle.load('assets/images/approve-2.png');
    final buffer = byteData.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = '$tempPath/file_01.tmp';
    return await File(filePath).writeAsBytes(
      buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
  }

  @override
  Future<Either<Failure, List<Attendance>>> getDailyAttendance({
    required String nik,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final attendances = await attendanceRemoteDatasource.getDailyAttendance(
        nik: nik,
      );

      return right(attendances);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecap>>> getAttendanceRecap({
    required String nik,
    required DateTimeRange range,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final attendances = await attendanceRemoteDatasource.getAttendaceRecap(
        nik: nik,
        startDate: range.start.toString().substring(0, 10),
        finishDate: range.end.toString().substring(0, 10),
      );

      return right(attendances);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DailyAttendance>>> getAttendanceDailyRecap({
    required String nik,
    required DateTimeRange range,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final attendances =
          await attendanceRemoteDatasource.getAttendaceDailyRecap(
        nik: nik,
        startDate: range.start.toString().substring(0, 10),
        finishDate: range.end.toString().substring(0, 10),
      );

      return right(attendances);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
