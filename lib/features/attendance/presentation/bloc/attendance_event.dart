part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

final class Authenticate extends AttendanceEvent {
  final String nik;
  final String kodeCabang;
  final double latitude;
  final double longitude;
  final AttendanceType type;
  final String? filePath;

  Authenticate({
    required this.nik,
    required this.kodeCabang,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.filePath,
  });
}
