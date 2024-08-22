import 'dart:async';

import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/domain/usecases/get_my_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';

part 'my_location_event.dart';

class MyLocationBloc extends BaseBloc<MyLocationEvent> {
  final GetMyLocation getMyLocation;
  MyLocationBloc(this.getMyLocation) : super() {
    on<GetCurrentLocation>(_getCurrentLocation);
  }

  FutureOr<void> _getCurrentLocation(
    GetCurrentLocation event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await getMyLocation(
      GetMyLocationParams(
        allowMockLocation: event.allowMockLocation,
        kodeCabang: event.kodeCabang,
        nik: event.nik,
        type: event.type,
        centerLatitude: event.centerLatitude,
        centerLongitude: event.centerLongitude,
        radius: event.radius,
      ),
    );

    response.fold(
      (failure) {
        emit(FailureState(failure.message));
      },
      (rule) {
        emit(SuccessState(rule));
      },
    );
  }
}
