import 'dart:async';

import 'package:easy/features/account/domain/usecases/get_current_position.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'position_event.dart';

class PositionBloc extends BaseBloc<PositionEvent> {
  final GetCurrentPosition getCurrentPosition;

  PositionBloc(this.getCurrentPosition) : super() {
    on<GetPosition>(_getPosition);
    on<ResetPosition>((event, emit) => emit(InitialState()));
  }

  FutureOr<void> _getPosition(
    GetPosition event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());
    final response = await getCurrentPosition(event.nik);

    response.fold(
      (failure) {
        emit(FailureState(failure.message));
      },
      (positions) {
        emit(SuccessState(positions));
      },
    );
  }
}
