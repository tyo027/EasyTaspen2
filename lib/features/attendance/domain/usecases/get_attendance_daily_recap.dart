import 'package:easy/features/attendance/domain/entities/daily_attendance.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class GetAttendanceDailyRecap
    implements UseCase<List<DailyAttendance>, GetAttendanceDailyRecapParams> {
  final AttendanceRepository repository;

  GetAttendanceDailyRecap(this.repository);

  @override
  Future<Either<Failure, List<DailyAttendance>>> call(
    GetAttendanceDailyRecapParams params,
  ) {
    return repository.getAttendanceDailyRecap(
      nik: params.nik,
      range: params.range,
    );
  }
}

class GetAttendanceDailyRecapParams {
  final String nik;
  final DateTimeRange range;

  GetAttendanceDailyRecapParams(
    this.nik,
    this.range,
  );
}
