import 'package:easy/features/attendance/domain/entities/rule.dart';

class RuleModel extends Rule {
  RuleModel({
    required super.name,
    required super.long,
    required super.lat,
    required super.jarak,
    required super.isAllowWFH,
    required super.isAllowWFO,
    required super.isAllowMockLocation,
  });

  factory RuleModel.fromJson(Map<String, dynamic> json) {
    return RuleModel(
      name: json['data']['name'],
      long: double.tryParse(json['data']['long']) ?? 0,
      lat: double.tryParse(json['data']['lat']) ?? 0,
      jarak: json['data']['jarak'],
      isAllowWFH: json['data']['allow_wfh'],
      isAllowWFO: json['data']['allow_wfo'],
      isAllowMockLocation: json['data']['allow_mock_location'],
    );
  }

  RuleModel copyWith({
    String? name,
    double? long,
    double? lat,
    int? jarak,
    bool? isAllowWFH,
    bool? isAllowWFO,
    bool? isAllowMockLocation,
  }) {
    return RuleModel(
      name: name ?? this.name,
      long: long ?? this.long,
      lat: lat ?? this.lat,
      jarak: jarak ?? this.jarak,
      isAllowWFH: isAllowWFH ?? this.isAllowWFH,
      isAllowWFO: isAllowWFO ?? this.isAllowWFO,
      isAllowMockLocation: isAllowMockLocation ?? this.isAllowMockLocation,
    );
  }
}
