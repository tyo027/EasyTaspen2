import 'dart:async';
import 'dart:convert';
import 'package:easy/models/location.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/authentication.repository.dart';
import 'package:easy/services/location.service.dart';
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

    if (!Storage.has("token") || !Storage.has("user")) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));

      // Check for v1.1

      var location = const LocationModel(long: 0, lat: 0);

      var mpp = await AuthenticationRepository().getMpp(user.nik);
      if (mpp != null && mpp.custom == 1) {
        location = location.copyWith(lat: mpp.lat, long: mpp.long);
      }

      var rules = await AuthenticationRepository().getRules(user.ba);
      if (rules == null) {
        emit(const AuthenticationState.expired());
        return;
      }

      if (location.lat == 0) {
        location = location.copyWith(lat: rules.lat, long: rules.long);
      }

      user = user.copyWith(
          latitude: location.lat,
          longitude: location.long,
          allowWFA: rules.allowWFA,
          allowWFO: rules.allowWFO,
          allowMock: rules.allowMock,
          radius: rules.radius);

      await Storage.write("user", json.encode(user.toJson()));

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
    Storage.deactivate();
    LocationService.reset();
    emit(const AuthenticationState.unauthenticated());
  }

  FutureOr<void> onExpiredRequested(
      AuthenticationExpiredRequested event, Emitter emit) async {
    Storage.deactivate();
    emit(const AuthenticationState.expired());
  }
}
