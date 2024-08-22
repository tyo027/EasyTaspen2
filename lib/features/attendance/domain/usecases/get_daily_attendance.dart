import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetDailyAttendance implements UseCase<List<Attendance>, String> {
  final AttendanceRepository repository;

  GetDailyAttendance(this.repository);

  @override
  Future<Either<Failure, List<Attendance>>> call(String nik) {
    return repository.getDailyAttendance(nik: nik);
  }
}
