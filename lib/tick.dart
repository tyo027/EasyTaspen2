import 'package:async/async.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tick {
  static RestartableTimer? _timer;
  static var isLoginPage = Storage.status();
  static BuildContext? context;

  static start(BuildContext? context) {
    Tick.context = context;
    _timer ??= RestartableTimer(const Duration(minutes: 10), () {
      if (Storage.status()) {
        Tick.context!
            .read<AuthenticationBloc>()
            .add(AuthenticationExpiredRequested());
      }
    });
  }

  static reset() {
    if (!Storage.status()) {
      _timer!.reset();
    }
  }
}
