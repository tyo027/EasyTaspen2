import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:easy/features/attendance/domain/entities/attendance_recap.dart';
import 'package:easy/features/attendance/domain/entities/daily_attendance.dart';
import 'package:easy/features/attendance/domain/enums/attendance_report_type.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_report_bloc.dart';
import 'package:easy/features/attendance/presentation/widget/cek_absensi_harian_tile.dart';
import 'package:easy/features/attendance/presentation/widget/kehadiran_verified_tile.dart';
import 'package:easy/features/attendance/presentation/widget/rekap_kehadiran_tile.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';

class ReportResult extends StatelessWidget {
  final AttendanceReportType type;
  const ReportResult({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<AttendanceReportBloc, Object>(
      builder: (context, state) {
        if (state is SuccessState<List<Attendance>> &&
            type == AttendanceReportType.cekAbsensiHarian) {
          return CekAbsensiHarianTile(attendances: state.data);
        } else if (state is SuccessState<List<AttendanceRecap>> &&
            type == AttendanceReportType.rekapKehadiran) {
          return RekapKehadiranTile(recaps: state.data);
        } else if (state is SuccessState<List<DailyAttendance>> &&
            type == AttendanceReportType.kehadiranVerified) {
          return KehadiranVerifiedTile(attendances: state.data);
        }
        return const SizedBox();
      },
    );
  }
}
