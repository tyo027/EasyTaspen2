import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegisterFullnameChanged>(onFullnameChanged);
    on<RegisterUserNameChanged>(onUsernameChanged);
    on<RegisterPasswordChanged>(onPasswordChanged);
  }

  FutureOr<void> onFullnameChanged(
      RegisterFullnameChanged event, Emitter emit) async {
    emit(state.copyWith(fullname: event.fullname));
  }

  FutureOr<void> onUsernameChanged(
      RegisterUserNameChanged event, Emitter emit) async {
    emit(state.copyWith(userName: event.userName));
  }

  FutureOr<void> onPasswordChanged(
      RegisterPasswordChanged event, Emitter emit) async {
    emit(state.copyWith(password: event.password));
  }
}
