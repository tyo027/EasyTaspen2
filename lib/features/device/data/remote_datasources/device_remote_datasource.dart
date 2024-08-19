import 'dart:convert';

import 'package:easy/core/constants/api.dart';
import 'package:easy/features/device/data/models/device_response_model.dart';
import 'package:fca/fca.dart';

abstract interface class DeviceRemoteDatasource {
  Future<DeviceResponseModel> registerDevice(
      {required String username,
      required String nik,
      required String uuid,
      required String fcmToken,
      required String deviceName,
      required String appVersion,
      required String osVersion});
}

class DeviceRemoteDatasourceImpl implements DeviceRemoteDatasource {
  InterceptedClient client;

  DeviceRemoteDatasourceImpl(this.client);

  @override
  Future<DeviceResponseModel> registerDevice({
    required String username,
    required String nik,
    required String uuid,
    required String fcmToken,
    required String deviceName,
    required String appVersion,
    required String osVersion,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(Api.deviceId),
        body: jsonEncode({
          "username": username,
          "uuid": uuid,
          "fcm_token": fcmToken,
          "nik": nik,
          "device_name": deviceName,
          "app_version": appVersion,
          "os_version": osVersion,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return DeviceResponseModel.fromJson(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
