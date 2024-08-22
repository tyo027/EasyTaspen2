import 'package:device_uuid/device_uuid.dart';
import 'package:easy/core/constants/constants.dart';
import 'package:easy/core/utils/device_model.dart';
import 'package:easy/core/utils/messanging.dart';
import 'package:easy/features/device/data/remote_datasources/device_remote_datasource.dart';
import 'package:easy/features/device/domain/repositories/device_repository.dart';
import 'package:fca/fca.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDatasource deviceRemoteDatasource;
  final ConnectionChecker connectionChecker;

  DeviceRepositoryImpl(this.deviceRemoteDatasource, this.connectionChecker);

  @override
  Future<Either<Failure, bool>> registerDevice({
    required String username,
    required String nik,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final uuid = await DeviceUuid().getUUID();

      if (uuid == null) {
        return left(Failure("Cannot get Device Id"));
      }

      final fcmToken = await Messanging.getToken();

      if (fcmToken == null) {
        return left(Failure("Cannot messanging token"));
      }

      final device = await getDeviceModel();

      final register = await deviceRemoteDatasource.registerDevice(
        username: username,
        nik: nik,
        uuid: uuid,
        fcmToken: fcmToken,
        deviceName: device.name,
        appVersion: device.appVersion,
        osVersion: device.osVersion,
      );

      if (register.status && nik != dotenv.env['DEVELOPER_NIK']) {
        return left(Failure("Account already logged in other device!"));
      }

      return right(true);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> resetDevice({
    required String username,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      await deviceRemoteDatasource.resetDevice(
        username: username,
      );

      return right(true);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
