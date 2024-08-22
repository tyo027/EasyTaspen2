import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:easy/features/attendance/domain/entities/attendance_recap.dart';
import 'package:easy/features/attendance/domain/entities/daily_attendance.dart';
import 'package:easy/features/attendance/domain/entities/my_location.dart';
import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AttendanceRepository {
  Future<Either<Failure, Rule>> getRule({
    required String codeCabang,
    required String nik,
  });

  Future<Either<Failure, MyLocation>> getMyLocation({
    required bool allowMockLocation,
    required String kodeCabang,
    required String nik,
    required AttendanceType type,
    required int radius,
    required double centerLatitude,
    required double centerLongitude,
  });

  Future<Either<Failure, bool>> submitAttendance({
    required String nik,
    required String kodeCabang,
    required double latitude,
    required double longitude,
    required AttendanceType type,
    String? filePath,
  });

  Future<Either<Failure, List<Attendance>>> getDailyAttendance({
    required String nik,
  });

  Future<Either<Failure, List<AttendanceRecap>>> getAttendanceRecap({
    required String nik,
    required DateTimeRange range,
  });

  Future<Either<Failure, List<DailyAttendance>>> getAttendanceDailyRecap({
    required String nik,
    required DateTimeRange range,
  });
}
