import 'package:easy/features/attendance/domain/entities/attendance_recap.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class GetAttendanceRecap
    implements UseCase<List<AttendanceRecap>, GetAttendanceRecapParams> {
  final AttendanceRepository repository;

  GetAttendanceRecap(this.repository);

  @override
  Future<Either<Failure, List<AttendanceRecap>>> call(
    GetAttendanceRecapParams params,
  ) {
    return repository.getAttendanceRecap(nik: params.nik, range: params.range);
  }
}

class GetAttendanceRecapParams {
  final String nik;
  final DateTimeRange range;

  GetAttendanceRecapParams(
    this.nik,
    this.range,
  );
}
