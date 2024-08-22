part of 'my_location_bloc.dart';

@immutable
sealed class MyLocationEvent {}

final class GetCurrentLocation extends MyLocationEvent {
  final String kodeCabang;
  final AttendanceType type;
  final String nik;
  final bool allowMockLocation;
  final int radius;
  final double centerLatitude;
  final double centerLongitude;

  GetCurrentLocation({
    required this.radius,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.allowMockLocation,
    required this.kodeCabang,
    required this.nik,
    required this.type,
  });
}
