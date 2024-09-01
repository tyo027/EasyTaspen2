import 'dart:async';

import 'package:easy/features/account/domain/usecases/get_current_golongan.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'golongan_event.dart';

class GolonganBloc extends BaseBloc<GolonganEvent> {
  final GetCurrentGolongan getCurrentGolongan;

  GolonganBloc(this.getCurrentGolongan) : super() {
    on<GetGolongan>(_getGolongan);
    on<ResetGolongan>((event, emit) => emit(InitialState()));
  }

  FutureOr<void> _getGolongan(
    GetGolongan event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());
    final response = await getCurrentGolongan(event.nik);

    response.fold(
      (failure) {
        emit(FailureState(failure.message));
      },
      (golongan) {
        emit(SuccessState(golongan));
      },
    );
  }
}
