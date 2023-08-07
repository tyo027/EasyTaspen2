import 'dart:async';
import 'dart:convert';
import 'package:easy/models/user.model.dart';
import 'package:easy/services/storage.service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.unknown()) {
    on<AuthenticationCheckRequested>(onCheckRequested);
    on<AuthenticationLoginRequested>(onLoginRequested);
    on<AuthenticationLogoutRequested>(onLogoutRequested);
    on<AuthenticationExpiredRequested>(onExpiredRequested);
  }

  FutureOr<void> onCheckRequested(
      AuthenticationCheckRequested event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 1));

    if (Storage.has("user")) {
      var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));
      if (!user.isActive) {
        emit(AuthenticationState.authenticated(user: user));
        return;
      }
    }

    if (!Storage.has("token") ||
        !Storage.has("user") ||
        !Storage.has("location")) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));
      if (event.check) await Storage.activate();
      if (!Storage.status()) {
        emit(const AuthenticationState.expired());
        return;
      }
      emit(AuthenticationState.authenticated(user: user));
    }
  }

  FutureOr<void> onLoginRequested(
      AuthenticationLoginRequested event, Emitter emit) async {
    Storage.activate();
    emit(AuthenticationState.authenticated(user: event.user));
  }

  FutureOr<void> onLogoutRequested(
      AuthenticationLogoutRequested event, Emitter emit) async {
    Storage.remove("token");
    Storage.remove("user");
    Storage.remove("location");
    Storage.deactivate();
    emit(const AuthenticationState.unauthenticated());
  }

  FutureOr<void> onExpiredRequested(
      AuthenticationExpiredRequested event, Emitter emit) async {
    Storage.deactivate();
    emit(const AuthenticationState.expired());
  }
}
