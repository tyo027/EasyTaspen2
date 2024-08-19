import 'dart:async';

import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:easy/features/idle/domain/usecase/activate_idle.dart';
import 'package:easy/features/idle/domain/usecase/get_idle_status.dart';
import 'package:easy/router.dart';
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

        result.fold((_) => _unAuthenticate(emit), (idleStatus) {
          if (idleStatus.isIdle) {
            emit(IdleActive());
          } else {
            _expired(emit);
          }
        });
      },
    );

    on<UserActivityDetected>(
      (event, emit) async {
        emit(IdleLoading());
        final result = await activateIdle(NoParams());

        result.fold((_) => _unAuthenticate(emit), (idleStatus) {
          if (idleStatus.isIdle) {
            emit(IdleActive());
          } else {
            _expired(emit);
          }
        });
      },
    );

    startIdleCheck();
  }

  void _expired(Emitter<IdleState> emit) {
    emit(IdleExpired());
    _idleTimer?.cancel();
    router.go(Uri(
      path: SignInPage.route,
      queryParameters: {'canUseBiometric': 'true'},
    ).toString());
  }

  void _unAuthenticate(Emitter<IdleState> emit) {
    emit(IdleExpired());
    _idleTimer?.cancel();
    router.go(Uri(
      path: SignInPage.route,
    ).toString());
  }

  void startIdleCheck() {
    _idleTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(CheckIdle());
    });
  }

  cancel() {
    _idleTimer?.cancel();
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }
}
