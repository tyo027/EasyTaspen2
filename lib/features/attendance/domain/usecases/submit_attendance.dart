import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class SubmitAttendance implements UseCase<void, SubmitAttendanceParams> {
  final AttendanceRepository repository;

  SubmitAttendance(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitAttendanceParams params) {
    return repository.submitAttendance(
      nik: params.nik,
      kodeCabang: params.kodeCabang,
      latitude: params.latitude,
      longitude: params.longitude,
      type: params.type,
    );
  }
}

class SubmitAttendanceParams {
  final String nik;
  final String kodeCabang;
  final double latitude;
  final double longitude;
  final AttendanceType type;

  SubmitAttendanceParams({
    required this.nik,
    required this.kodeCabang,
    required this.latitude,
    required this.longitude,
    required this.type,
  });
}
