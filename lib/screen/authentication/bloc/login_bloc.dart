// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:device_uuid/device_uuid.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/location.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/authentication.repository.dart';
import 'package:easy/repositories/device.repository.dart';
import 'package:easy/repositories/profile.repository.dart';
import 'package:easy/services/biometric.service.dart';
import 'package:easy/services/fcm.service.dart';
import 'package:easy/services/storage.service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginView view;
  final BuildContext context;
  final deviceUUID = DeviceUuid();
  final deviceRepository = DeviceRepository();
  final authenticationRepository = AuthenticationRepository();
  final profileRepository = ProfileRepository();

  LoginBloc(this.view, this.context) : super(const LoginState()) {
    on<LoginUsernameChanged>(onUserNameChanged);
    on<LoginPasswordChanged>(onPasswordChanged);
    on<LoginPasswordShowChanged>(onPasswordShowChanged);
    on<LoginRequestedEvent>(onLoginRequested);
    on<LoginRequestedBiometricEvent>(onLoginRequestedBiometric);
  }

  onUserNameChanged(LoginUsernameChanged event, Emitter emit) async {
    emit(state.copyWith(username: event.username));
  }

  onPasswordChanged(LoginPasswordChanged event, Emitter emit) async {
    emit(state.copyWith(password: event.password));
  }

  onPasswordShowChanged(LoginPasswordShowChanged event, Emitter emit) async {
    emit(state.copyWith(isPasswordShow: event.isPasswordShow));
  }

  onLoginRequested(LoginRequestedEvent event, emit) async {
    if (!state.isFilled && !context.mounted) return;
    view.showLoading(context);

    var uuid = await deviceUUID.getUUID();
    if (uuid == null) {
      view.hideLoading();
      view.showToast(context, "Gagal Mendapatkan DeviceID");
      return;
    }

    var username = !event.onBiometric
        ? state.username.toLowerCase()
        : Storage.read('username');
    var password =
        !event.onBiometric ? state.password : Storage.read('password');

    var auth = await deviceRepository.login(
        password: password, username: username, uuid: uuid);

    if (!auth.status) {
      view.hideLoading();
      view.showToast(context, auth.message);
      return;
    }

    await Storage.write("token", auth.token);

    // Adding password to storage
    await Storage.write("password", password);

    authenticationRepository.setJWTToken(auth.token);
    profileRepository.setJWTToken(auth.token);

    var location = const LocationModel(long: 0, lat: 0);

    var mpp = await authenticationRepository.getMpp(auth.nik);
    if (mpp != null && mpp.custom == 1) {
      location = location.copyWith(lat: mpp.lat, long: mpp.long);
    }

    await Storage.write("username", username);
    await Storage.write("uuid", uuid);

    FcmService.whenTokenUpdated(username, uuid, auth.nik);

    var rules = await authenticationRepository.getRules(auth.ba);

    if (rules == null) {
      view.hideLoading();
      view.showToast(context, "Tidak Dapat Menemukan Data Kantor");

      // reset token
      await Storage.remove("token");
      await Storage.remove("password");
      await Storage.remove("username");
      await Storage.remove("uuid");

      return;
    }

    if (location.lat == 0) {
      location = location.copyWith(lat: rules.lat, long: rules.long);
    }

    var userProfile = await profileRepository.getProfile(nik: auth.nik);
    if (userProfile == null) {
      view.hideLoading();
      view.showToast(context, "Data Tidak Ditemukan, Coba beberapa saat lagi");

      // reset token
      await Storage.remove("token");
      await Storage.remove("password");
      await Storage.remove("username");
      await Storage.remove("uuid");

      authenticationRepository.resetJWTToken();
      profileRepository.resetJWTToken();

      return;
    }

    var user = UserModel(
        nik: auth.nik,
        nama: auth.fullname,
        jabatan: auth.jabatan,
        ba: auth.ba,
        unitkerja: auth.unitKerja,
        perty: auth.perty,
        isActive: true,
        gender: userProfile.gender,
        latitude: location.lat,
        longitude: location.long,
        allowWFA: rules.allowWFA,
        allowWFO: rules.allowWFO,
        allowMock: rules.allowMock,
        radius: rules.radius);

    view.hideLoading();

    await Storage.write("user", json.encode(user.toJson()));

    context.read<AuthenticationBloc>().add(AuthenticationLoginRequested(
          user: user,
        ));
  }

  onLoginRequestedBiometric(LoginRequestedBiometricEvent event, emit) async {
    var isAuthenticate = await BiometricService.authenticate();
    if (!isAuthenticate) {
      view.showToast(context, "Failed to authenticate using biometric");
      return;
    }

    onLoginRequested(LoginRequestedEvent(onBiometric: true), emit);
  }
}

abstract class LoginView {
  void showLoading(BuildContext context);
  void hideLoading();
  void showToast(BuildContext context, String message);
}
