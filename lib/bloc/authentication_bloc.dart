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
  }

  FutureOr<void> onCheckRequested(
      AuthenticationCheckRequested event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 3));
    if (!Storage.has("token") ||
        !Storage.has("user") ||
        !Storage.has("location")) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));
      emit(AuthenticationState.authenticated(user: user));
    }
  }

  FutureOr<void> onLoginRequested(
      AuthenticationLoginRequested event, Emitter emit) async {
    emit(AuthenticationState.authenticated(user: event.user));
  }

  FutureOr<void> onLogoutRequested(
      AuthenticationLogoutRequested event, Emitter emit) async {
    Storage.remove("token");
    Storage.remove("user");
    Storage.remove("location");
    emit(const AuthenticationState.unauthenticated());
  }
}
