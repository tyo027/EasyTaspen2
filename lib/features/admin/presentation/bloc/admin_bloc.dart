import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy/features/device/domain/usecases/reset_device.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';

part 'admin_event.dart';

class AdminBloc extends BaseBloc<AdminEvent> {
  final ResetDevice _resetDevice;

  AdminBloc(this._resetDevice) : super() {
    on<ResetUserDevice>(_resetUserDevice);
  }

  FutureOr<void> _resetUserDevice(
    ResetUserDevice event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _resetDevice(event.username);

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (success) => emit(SuccessState(success)),
    );
  }
}
