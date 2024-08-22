import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/features/attendance/domain/enums/attendance_report_type.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_report_bloc.dart';
import 'package:easy/features/attendance/presentation/widget/report_button.dart';
import 'package:easy/features/attendance/presentation/widget/report_filter.dart';
import 'package:easy/features/attendance/presentation/widget/report_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  static String route = '/attendance/report';

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  AttendanceReportType type = AttendanceReportType.cekAbsensiHarian;

  DateTimeRange? timeRange;

  @override
  void initState() {
    super.initState();
    context.read<AttendanceReportBloc>().add(ResetAttendanceResult());
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Laporan Presensi",
      bottomWidget: (context, user) {
        return ReportButton(
          type: type,
          timeRange: timeRange,
          nik: user.nik,
        );
      },
      stackedWidget: (context, user) => [
        ReportFilter(
          onTypeChange: (type) {
            setState(() {
              this.type = type;
            });
          },
          onTimeRangeChange: (timeRange) {
            setState(() {
              this.timeRange = timeRange;
            });
          },
        )
      ],
      builder: (context, user) {
        return [ReportResult(type: type)];
      },
    );
  }
}
