import 'dart:async';

import 'package:easy/features/idle/domain/usecase/activate_idle.dart';
import 'package:easy/features/idle/domain/usecase/get_idle_status.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'idle_event.dart';
part 'idle_state.dart';

class IdleBloc extends Bloc<IdleEvent, IdleState> {
  Timer? _idleTimer;
  GetIdleStatus getIdleStatus;
  ActivateIdle activateIdle;

  IdleBloc(
    this.getIdleStatus,
    this.activateIdle,
  ) : super(IdleInitial()) {
    on<CheckIdle>(
      (event, emit) async {
        emit(IdleLoading());
        final result = await getIdleStatus(NoParams());

        result.fold((_) => emit(IdleExpired()), (idleStatus) {
          if (idleStatus.isIdle) {
            emit(IdleActive());
          } else {
            emit(IdleExpired());
          }
        });
      },
    );

    on<UserActivityDetected>(
      (event, emit) async {
        emit(IdleLoading());
        final result = await activateIdle(NoParams());

        result.fold((_) => emit(IdleExpired()), (idleStatus) {
          if (idleStatus.isIdle) {
            emit(IdleActive());
          } else {
            emit(IdleExpired());
          }
        });
      },
    );

    _startIdleCheck();
  }

  void _startIdleCheck() {
    _idleTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(CheckIdle());
    });
  }

  @override
  Future<void> close() {
    _idleTimer?.cancel();
    return super.close();
  }
}
