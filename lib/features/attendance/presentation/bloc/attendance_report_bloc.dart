import 'dart:async';

import 'package:easy/features/attendance/domain/usecases/get_attendance_daily_recap.dart';
import 'package:easy/features/attendance/domain/usecases/get_attendance_recap.dart';
import 'package:easy/features/attendance/domain/usecases/get_daily_attendance.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_report_event.dart';

class AttendanceReportBloc extends BaseBloc<AttendanceReportEvent> {
  final GetDailyAttendance _getDailyAttendance;
  final GetAttendanceRecap _getAttendanceRecap;
  final GetAttendanceDailyRecap _getAttendanceDailyRecap;

  AttendanceReportBloc(
    this._getDailyAttendance,
    this._getAttendanceRecap,
    this._getAttendanceDailyRecap,
  ) : super() {
    on<LoadDailyAttendance>(_dailyAttendance);
    on<LoadAttendanceRecap>(_attendanceRecap);
    on<LoadAttendanceDailyRecap>(_attendanceDailyRecap);
  }

  FutureOr<void> _dailyAttendance(
    LoadDailyAttendance event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _getDailyAttendance(event.nik);

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (success) => emit(SuccessState(success)),
    );
  }

  FutureOr<void> _attendanceRecap(
    LoadAttendanceRecap event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _getAttendanceRecap(
      GetAttendanceRecapParams(
        event.nik,
        event.range,
      ),
    );

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (success) => emit(SuccessState(success)),
    );
  }

  FutureOr<void> _attendanceDailyRecap(
    LoadAttendanceDailyRecap event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _getAttendanceDailyRecap(
      GetAttendanceDailyRecapParams(
        event.nik,
        event.range,
      ),
    );

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (success) => emit(SuccessState(success)),
    );
  }
}
