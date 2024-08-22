import 'dart:async';

import 'package:easy/core/utils/biometric.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/domain/usecases/submit_attendance.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_event.dart';

class AttendanceBloc extends BaseBloc<AttendanceEvent> {
  final SubmitAttendance submitAttendance;
  AttendanceBloc(
    this.submitAttendance,
  ) : super() {
    on<Authenticate>(_authenticate);
  }

  FutureOr<void> _authenticate(
    Authenticate event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    try {
      if (event.filePath == null) {
        await Biometric.authenticate(
            reason: "Gunakan FaceID/Fingerprint untuk absen");
      }

      final response = await submitAttendance(
        SubmitAttendanceParams(
          nik: event.nik,
          kodeCabang: event.kodeCabang,
          latitude: event.latitude,
          longitude: event.longitude,
          type: event.type,
        ),
      );

      response.fold(
        (failure) => emit(FailureState(failure.message)),
        (rule) => emit(SuccessState(rule)),
      );
    } catch (e) {
      emit(FailureState("BIOMETRIC_FAILED"));
    }

// final response = await getRule(
//       GetRuleParams(
//         codeCabang: event.codeCabang,
//         nik: event.nik,
//       ),
//     );

    //  response.fold(
    //   (failure) {
    //     emit(FailureState(failure.message));
    //   },
    //   (rule) {
    //     emit(SuccessState(rule));
    //   },
    // );
  }
}
