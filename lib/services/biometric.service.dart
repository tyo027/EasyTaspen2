import 'dart:math';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> isDeviceSupported() async {
    return await auth.canCheckBiometrics || await auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    bool isDeviceSupport = await isDeviceSupported();

    if (!isDeviceSupport) return false;

    try {
      var isSuccess = await auth.authenticate(
        localizedReason: "Gunakan FaceID untuk absen",
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          biometricOnly: true,
        ),
      );
      if (isSuccess) {
        return true;
      } else {}
    } catch (e) {
      print(e);
      return false;
    }

    return false;
  }
}
