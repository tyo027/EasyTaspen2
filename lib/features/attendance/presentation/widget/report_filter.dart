import 'package:easy/core/common/widgets/dropdown_field_widget.dart';
import 'package:easy/core/common/widgets/text_field_widget.dart';
import 'package:easy/core/utils/month_picker_dialog.dart';
import 'package:easy/core/utils/range_picker_dialog.dart';
import 'package:easy/core/utils/select_dialog.dart';
import 'package:easy/extension.dart';
import 'package:easy/features/attendance/domain/enums/attendance_report_type.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ReportFilter extends StatefulWidget {
  final Function(AttendanceReportType type) onTypeChange;
  final Function(DateTimeRange? timeRange) onTimeRangeChange;

  const ReportFilter({
    super.key,
    required this.onTypeChange,
    required this.onTimeRangeChange,
  });

  @override
  State<ReportFilter> createState() => _ReportFilterState();
}

class _ReportFilterState extends State<ReportFilter> {
  AttendanceReportType type = AttendanceReportType.cekAbsensiHarian;
  final TextEditingController _dateController = TextEditingController();
  DateTimeRange? timeRange;

  @override
  Widget build(BuildContext context) {
    return Column(
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

                widget.onTimeRangeChange(null);
                widget.onTypeChange(value);

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
              widget.onTimeRangeChange(timeRange);
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
                  widget.onTimeRangeChange(timeRange);
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
                  widget.onTimeRangeChange(timeRange);
                });
              },
            );
          }
        },
      );
    }
  }
}
