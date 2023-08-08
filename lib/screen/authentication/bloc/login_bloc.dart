import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginUserNameChanged>(onUserNameChanged);
    on<LoginPasswordChanged>(onPasswordChanged);
    on<LoginPasswordShowChanged>(onPasswordShowChanged);
  }

  FutureOr<void> onUserNameChanged(
      LoginUserNameChanged event, Emitter emit) async {
    emit(state.copyWith(userName: event.userName));
  }

  FutureOr<void> onPasswordChanged(
      LoginPasswordChanged event, Emitter emit) async {
    emit(state.copyWith(password: event.password));
  }

  FutureOr<void> onPasswordShowChanged(
      LoginPasswordShowChanged event, Emitter emit) async {
    emit(state.copyWith(isPasswordShow: event.isPasswordShow));
  }
}
