import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy/models/location.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/authentication.repository.dart';
import 'package:easy/repositories/device.repository.dart';
import 'package:easy/services/fcm.service.dart';
import 'package:easy/services/location.service.dart';
import 'package:easy/services/notification.service.dart';
import 'package:easy/services/permission.service.dart';
import 'package:easy/services/storage.service.dart';
import 'package:easy/services/version.service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Unknown()) {
    on<AuthenticationCheckRequested>(onCheckRequested);
    on<AuthenticationLoginRequested>(onLoginRequested);
    on<AuthenticationLogoutRequested>(onLogoutRequested);
    on<AuthenticationExpiredRequested>(onExpiredRequested);
  }

  FutureOr<void> onCheckRequested(
      AuthenticationCheckRequested event, Emitter emit) async {
    // Check permissions
    // var hasAllowAllPermission = await PermissionService.requestPermission();
    // if (!hasAllowAllPermission) {
    //   emit(NeedPermissions());
    //   return;
    // }

    //cek permission

    if (!event.isBiometric) {
      if (Platform.isAndroid) {
        await PermissionService.requestPermission();
      }

      // Check versions
      var version = await VersionService().checkUpdate();
      if (version.canUpdate) {
        emit(NeedUpdate(version: version));
        return;
      }

      await Future.delayed(const Duration(seconds: 1));
      await NotificationService.init();
      await NotificationService.loadAllNotification();
    }

    // if (Storage.has("user")) {
    //   var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));
    //   if (!user.isActive) {
    //     emit(Authenticated(user: user));
    //     return;
    //   }
    // }

    if (!Storage.has("token") ||
        !Storage.has("user") ||
        !Storage.has("username") ||
        !Storage.has("uuid")) {
      return emit(UnAuthenticated());
    }

    var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));

    if (!user.isActive) return emit(Authenticated(user: user));

    // Check for v1.1

    var location = const LocationModel(long: 0, lat: 0);

    var mpp = await AuthenticationRepository().getMpp(user.nik);
    if (mpp != null && mpp.custom == 1) {
      location = location.copyWith(lat: mpp.lat, long: mpp.long);
    }

    var rules = await AuthenticationRepository().getRules(user.ba);
    if (rules == null) {
      emit(Expired());
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

    if (event.isBiometric) {
      var fcmToken = await FcmService.getToken();
      if (fcmToken == null) {
        emit(Expired());
        return;
      }
      await DeviceRepository().setToken(
          username: Storage.read('username'),
          uuid: Storage.read('uuid'),
          fcmToken: fcmToken,
          nik: user.nik);
      await Storage.activate();
      return emit(Authenticated(user: user));
    }
    if (!Storage.status()) {
      emit(Expired());
      return;
    }
    emit(Authenticated(user: user));
  }

  FutureOr<void> onLoginRequested(
      AuthenticationLoginRequested event, Emitter emit) async {
    Storage.activate();
    emit(Authenticated(user: event.user));
  }

  FutureOr<void> onLogoutRequested(
      AuthenticationLogoutRequested event, Emitter emit) async {
    Storage.remove("token");
    Storage.remove("user");
    Storage.remove("username");
    Storage.remove("uuid");
    Storage.deactivate();
    LocationService.reset();
    emit(UnAuthenticated());
  }

  FutureOr<void> onExpiredRequested(
      AuthenticationExpiredRequested event, Emitter emit) async {
    Storage.deactivate();
    emit(Expired());
  }
}
