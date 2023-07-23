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
    on<RegisterGenderChanged>(onGenderChanged);
    on<RegisterPhoneChanged>(onPhoneChanged);
    on<RegisterJobChanged>(onJobChanged);
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

  FutureOr<void> onGenderChanged(
      RegisterGenderChanged event, Emitter emit) async {
    emit(state.copyWith(gender: event.gender));
  }

  FutureOr<void> onPhoneChanged(
      RegisterPhoneChanged event, Emitter emit) async {
    emit(state.copyWith(phone: event.phone));
  }

  FutureOr<void> onJobChanged(RegisterJobChanged event, Emitter emit) async {
    emit(state.copyWith(job: event.job));
  }
}
