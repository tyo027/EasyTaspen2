import 'package:equatable/equatable.dart';

ruleModelFromJson(List<dynamic> list) =>
    List<RuleModel>.from(list.map((json) => RuleModel.fromJson(json)));

class RuleModel extends Equatable {
  final String name;
  final double long;
  final double lat;
  final int radius;
  final bool allowWFA;
  final bool allowWFO;
  final bool allowMock;

  const RuleModel({
    required this.name,
    required this.long,
    required this.lat,
    required this.radius,
    required this.allowWFA,
    required this.allowWFO,
    required this.allowMock,
  });

  static RuleModel fromJson(Map<String, dynamic> json) => RuleModel(
        name: json['name'],
        long: double.parse(json['long']),
        lat: double.parse(json['lat']),
        radius: json['jarak'],
        allowWFA: json['allow_wfh'],
        allowWFO: json['allow_wfo'],
        allowMock: json['allow_mock_location'],
      );

  @override
  List<Object> get props =>
      [name, long, lat, radius, allowWFA, allowWFO, allowMock];
}
