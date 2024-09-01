import 'dart:async';

import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/features/account/presentation/bloc/account_bloc.dart';
import 'package:easy/features/account/presentation/bloc/golongan_bloc.dart';
import 'package:easy/features/account/presentation/bloc/position_bloc.dart';
import 'package:easy/features/auth/domain/usecase/current_user.dart';
import 'package:easy/features/auth/domain/usecase/logout.dart';
import 'package:easy/features/auth/domain/usecase/re_authenticate.dart';
import 'package:easy/features/auth/domain/usecase/sign_in.dart';
import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:easy/features/idle/presentation/bloc/idle_bloc.dart';
import 'package:easy/router.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

class AuthBloc extends BaseBloc<AuthEvent> {
  final AppUserCubit _userCubit;

  final SignIn _signIn;
  final CurrentUser _currentUser;
  final ReAuthenticate _reAuthenticate;
  final Logout logout;
  final IdleBloc idleBloc;
  final AccountBloc accountBloc;
  final GolonganBloc golonganBloc;
  final PositionBloc positionBloc;

  AuthBloc(
    this._userCubit,
    this._signIn,
    this._currentUser,
    this._reAuthenticate,
    this.logout,
    this.idleBloc,
    this.accountBloc,
    this.golonganBloc,
    this.positionBloc,
  ) : super() {
    on<IsUserLogged>(_isUserLogged);

    on<Authenticate>(_authenticate);

    on<UseBiometricAuth>(_biometicAuth);

    on<LogoutNow>(_logout);
  }

  FutureOr<void> _isUserLogged(
    IsUserLogged event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _currentUser(NoParams());

    response.fold(
      (failure) {
        emit(FailureState(failure.message));

        _userCubit.updateUser(null);
      },
      (user) {
        emit(SuccessState(user));
        idleBloc.startIdleCheck();
        _userCubit.updateUser(user);
      },
    );
  }

  FutureOr<void> _authenticate(
    Authenticate event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _signIn(
      SignInParams(
        username: event.username.toLowerCase(),
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (user) {
        emit(SuccessState(user));
        idleBloc.startIdleCheck();
        _userCubit.updateUser(user);
      },
    );
  }

  FutureOr<void> _biometicAuth(
    UseBiometricAuth event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await _reAuthenticate(NoParams());

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (user) {
        emit(SuccessState(user));
        idleBloc.startIdleCheck();
        _userCubit.updateUser(user);
      },
    );
  }

  FutureOr<void> _logout(
    LogoutNow event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    await logout();

    _userCubit.updateUser(null);
    idleBloc.cancel();
    accountBloc.add(ResetAccount());
    golonganBloc.add(ResetGolongan());
    positionBloc.add(ResetPosition());
    router.go(SignInPage.route);
  }
}
