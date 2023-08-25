import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double long;
  final double lat;

  const LocationModel({
    required this.long,
    required this.lat,
  });

  LocationModel copyWith({double? long, double? lat}) => LocationModel(
        long: long ?? this.long,
        lat: lat ?? this.lat,
      );

  static LocationModel fromJson(Map<String, dynamic> json) => LocationModel(
        long: double.parse(json['long']),
        lat: double.parse(json['lat']),
      );

  Map<String, dynamic> toJson() => {
        'long': long.toString(),
        'lat': lat.toString(),
      };

  @override
  List<Object> get props => [
        long,
        lat,
      ];
}
