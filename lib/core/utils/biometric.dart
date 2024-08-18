import 'package:fca/fca.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Biometric {
  static final LocalAuthentication _authentication = LocalAuthentication();

  static Future<bool> _isDeviceSupported() async {
    return await _authentication.canCheckBiometrics ||
        await _authentication.isDeviceSupported();
  }

  static Future<bool> authenticate({required String reason}) async {
    try {
      bool isDeviceSupport = await _isDeviceSupported();

      if (!isDeviceSupport) {
        throw const ServerException('Device not supported');
      }

      var isGranted = await _authentication.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          biometricOnly: true,
        ),
      );

      return isGranted;
    } on PlatformException catch (e) {
      throw ServerException(e.message ?? e.details);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
