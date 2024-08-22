import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/features/attendance/domain/enums/attendance_report_type.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_report_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportButton extends StatelessWidget {
  final AttendanceReportType type;
  final DateTimeRange? timeRange;
  final String nik;
  final bool isActive;

  const ReportButton({
    super.key,
    required this.type,
    required this.timeRange,
    required this.nik,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWidget.primary(
      "Cari",
      onPressed: isActive
          ? type == AttendanceReportType.cekAbsensiHarian
              ? () => _cekAbsensiHarian(context)
              : type == AttendanceReportType.rekapKehadiran && timeRange != null
                  ? () => _rekapKehadiran(context)
                  : type == AttendanceReportType.kehadiranVerified &&
                          timeRange != null
                      ? () => _kehadiranVerified(context)
                      : null
          : null,
    );
  }

  _cekAbsensiHarian(BuildContext context) {
    context.read<AttendanceReportBloc>().add(LoadDailyAttendance(nik));
  }

  _rekapKehadiran(BuildContext context) {
    context
        .read<AttendanceReportBloc>()
        .add(LoadAttendanceRecap(nik, timeRange!));
  }

  _kehadiranVerified(BuildContext context) {
    context
        .read<AttendanceReportBloc>()
        .add(LoadAttendanceDailyRecap(nik, timeRange!));
  }
}
