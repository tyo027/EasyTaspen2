import 'dart:async';

import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/common/entities/user.dart';
import 'package:easy/features/auth/domain/usecase/current_user.dart';
import 'package:easy/features/auth/domain/usecase/re_authenticate.dart';
import 'package:easy/features/auth/domain/usecase/sign_in.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

class AuthBloc extends BaseBloc<AuthEvent> {
  final AppUserCubit _userCubit;

  final SignIn _signIn;
  final CurrentUser _currentUser;
  final ReAuthenticate _reAuthenticate;

  AuthBloc(
    this._userCubit,
    this._signIn,
    this._currentUser,
    this._reAuthenticate,
  ) : super() {
    on<IsUserLogged>(_isUserLogged);

    on<Authenticate>(_authenticate);

    on<UseBiometricAuth>(_biometicAuth);
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
      (auth) {
        final user = User(
          nik: auth.nik,
          nama: auth.nama,
          jabatan: auth.jabatan,
          ba: auth.ba,
          unitKerja: auth.unitKerja,
          perty: auth.perty,
        );
        emit(SuccessState(user));
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
        username: event.username,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(FailureState(failure.message)),
      (auth) {
        final user = User(
          nik: auth.nik,
          nama: auth.nama,
          jabatan: auth.jabatan,
          ba: auth.ba,
          unitKerja: auth.unitKerja,
          perty: auth.perty,
        );
        emit(SuccessState(user));
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
      (auth) {
        final user = User(
          nik: auth.nik,
          nama: auth.nama,
          jabatan: auth.jabatan,
          ba: auth.ba,
          unitKerja: auth.unitKerja,
          perty: auth.perty,
        );
        emit(SuccessState(user));
        _userCubit.updateUser(user);
      },
    );
  }
}
