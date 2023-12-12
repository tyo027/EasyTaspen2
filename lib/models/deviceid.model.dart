// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

deviceIdModelFromJson(List<dynamic> list) =>
    List<DeviceIdModel>.from(list.map((json) => DeviceIdModel.fromJson(json)));

class DeviceIdModel extends Equatable {
  final String device_name;
  final String app_version;
  final String os_version;

  const DeviceIdModel({
    required this.device_name,
    required this.app_version,
    required this.os_version,
  });

  static DeviceIdModel fromJson(Map<String, dynamic> json) => DeviceIdModel(
        device_name: json['device_name'],
        app_version: json['app_version'],
        os_version: json['os_version'],
      );

  @override
  List<Object> get props => [
        device_name,
        app_version,
        os_version,
      ];
}
