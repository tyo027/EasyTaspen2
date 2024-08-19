import 'package:easy/features/device/domain/entities/device_response.dart';

class DeviceResponseModel extends DeviceResponse {
  DeviceResponseModel({required super.status, required super.message});

  factory DeviceResponseModel.fromJson(Map<String, dynamic> json) {
    return DeviceResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
