import 'package:easy/features/attendance/domain/enums/attendance_type.dart';

class Attendance {
  final DateTime date;
  final String sapFlag;
  final AttendanceType type;

  Attendance({
    required this.date,
    required this.sapFlag,
    required this.type,
  });
}
