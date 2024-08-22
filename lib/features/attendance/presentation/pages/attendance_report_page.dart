import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/core/common/widgets/dropdown_field_widget.dart';
import 'package:easy/core/common/widgets/text_field_widget.dart';
import 'package:easy/core/utils/month_picker_dialog.dart';
import 'package:easy/core/utils/range_picker_dialog.dart';
import 'package:easy/core/utils/select_dialog.dart';
import 'package:easy/extension.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const AttendanceReportPage());

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  AttendanceReportType type = AttendanceReportType.cekAbsensiHarian;

  DateTimeRange? timeRange;

  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Laporan Presensi",
      bottomWidget: (context, user) {
        return ButtonWidget.primary(
          "Cari",
          onPressed: type == AttendanceReportType.cekAbsensiHarian
              ? () => _cekAbsensiHarian(context, user.nik)
              : type == AttendanceReportType.rekapKehadiran && timeRange != null
                  ? () => _rekapKehadiran(context, user.nik)
                  : type == AttendanceReportType.kehadiranVerified &&
                          timeRange != null
                      ? () => _kehadiranVerified(context, user.nik)
                      : null,
        );
      },
      stackedWidget: (context, user) => [filter()],
      builder: (context, user) {
        return [result()];
      },
    );
  }

  Widget result() {
    return BaseConsumer<AttendanceReportBloc, Object>(
      loading: true,
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

  Container filter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DropdownFieldWidget<AttendanceReportType>(
            "Jenis Laporan",
            value: type,
            items: AttendanceReportType.values
                .map(
                  (item) => DropdownItem(
                    text: item.name.camelToCapitalizedWords(),
                    value: item,
                  ),
                )
                .toList(),
            onChange: (value) {
              if (value != null) {
                setState(() {
                  type = value;
                  timeRange = null;

                  _dateController.text = "";
                });
              }
            },
          ),
          if ([
            AttendanceReportType.kehadiranVerified,
            AttendanceReportType.rekapKehadiran,
          ].contains(type))
            const Gap(16),
          if ([
            AttendanceReportType.kehadiranVerified,
            AttendanceReportType.rekapKehadiran,
          ].contains(type))
            TextFieldWidget(
              type == AttendanceReportType.rekapKehadiran
                  ? "Bulan / Tahun"
                  : 'Dari s/d Sampai',
              controller: _dateController,
              onTap: _selectDateDialog,
            ),
        ],
      ),
    );
  }

  void _selectDateDialog(context) {
    if (type == AttendanceReportType.rekapKehadiran) {
      monthPickerDialog(
        context,
        initialDate: timeRange?.start,
        onSelected: (selectedMonth) {
          if (selectedMonth != null) {
            if (type == AttendanceReportType.rekapKehadiran) {
              _dateController.text =
                  DateFormat("MMMM yyyy", 'id_ID').format(selectedMonth);
            }
            setState(() {
              timeRange = DateTimeRange(
                start: selectedMonth.copyWith(day: 1),
                end: selectedMonth
                    .copyWith(day: 1)
                    .copyWith(month: selectedMonth.month + 1, day: 0),
              );
            });
          }
        },
      );
    } else {
      selectDialog(
        context,
        title: "Berdasarkan",
        items: [
          SelectDialogItem(text: "Pilih Range Tanggal", value: "RANGE_TANGGAL"),
          SelectDialogItem(text: "Pilih Bulan", value: "BULAN")
        ],
        onSelected: (selected) {
          if (selected == null) return;

          if (selected == "BULAN") {
            monthPickerDialog(
              context,
              initialDate: timeRange?.start,
              onSelected: (selectedMonth) {
                if (selectedMonth == null) return;

                var start = selectedMonth.copyWith(day: 1);
                var end = start.copyWith(month: start.month + 1, day: 0);

                _dateController.text =
                    '${DateFormat("dd MMM yyyy", 'id_ID').format(start)}'
                    ' s/d '
                    '${DateFormat("dd MMM yyyy", 'id_ID').format(end)}';

                setState(() {
                  timeRange = DateTimeRange(start: start, end: end);
                });
              },
            );
          }

          if (selected == 'RANGE_TANGGAL') {
            rangePickerDialog(
              context,
              onSelected: (selected) {
                if (selected == null) return;

                _dateController.text =
                    '${DateFormat("dd MMM yyyy", 'id_ID').format(selected.start)}'
                    ' s/d '
                    '${DateFormat("dd MMM yyyy", 'id_ID').format(selected.end)}';

                setState(() {
                  timeRange = selected;
                });
              },
            );
          }
        },
      );
    }
  }

  _cekAbsensiHarian(BuildContext context, String nik) {
    context.read<AttendanceReportBloc>().add(LoadDailyAttendance(nik));
  }

  _rekapKehadiran(BuildContext context, String nik) {
    context
        .read<AttendanceReportBloc>()
        .add(LoadAttendanceRecap(nik, timeRange!));
  }

  _kehadiranVerified(BuildContext context, String nik) {
    context
        .read<AttendanceReportBloc>()
        .add(LoadAttendanceDailyRecap(nik, timeRange!));
  }
}
