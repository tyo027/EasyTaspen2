part of 'attendance_report_bloc.dart';

@immutable
sealed class AttendanceReportEvent {}

final class LoadDailyAttendance extends AttendanceReportEvent {
  final String nik;

  LoadDailyAttendance(this.nik);
}

final class LoadAttendanceRecap extends AttendanceReportEvent {
  final String nik;
  final DateTimeRange range;

  LoadAttendanceRecap(
    this.nik,
    this.range,
  );
}

final class LoadAttendanceDailyRecap extends AttendanceReportEvent {
  final String nik;
  final DateTimeRange range;

  LoadAttendanceDailyRecap(
    this.nik,
    this.range,
  );
}
