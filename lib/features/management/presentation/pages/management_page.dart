import 'package:easy/core/common/entities/employee.dart';
import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/dropdown_field_widget.dart';
import 'package:easy/features/attendance/domain/enums/attendance_report_type.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_report_bloc.dart';
import 'package:easy/features/attendance/presentation/widget/report_button.dart';
import 'package:easy/features/attendance/presentation/widget/report_filter.dart';
import 'package:easy/features/attendance/presentation/widget/report_result.dart';
import 'package:easy/features/home/domain/entities/home.dart';
import 'package:easy/features/home/presentation/bloc/home_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:easy/extension.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  static String route = '/management';

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  Employee? selectedEmployee;

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
      title: "Absensi Staff",
      bottomWidget: (context, user) {
        return ReportButton(
          type: type,
          timeRange: timeRange,
          nik: selectedEmployee?.nik ?? '',
          isActive: selectedEmployee != null,
        );
      },
      stackedWidget: (context, user) {
        return [
          BaseConsumer<HomeBloc, Home>(builder: (context, state) {
            if (state is SuccessState<Home>) {
              if (state.data.employee == null) {
                return const Text("Anda tidak memiliki Employee");
              }
              return DropdownFieldWidget<Employee>(
                "Staff",
                value: selectedEmployee,
                items: state.data.employee!
                    .map(
                      (employee) => DropdownItem(
                        text:
                            "${employee.nama.capitalize()} (${employee.nipp})",
                        value: employee,
                      ),
                    )
                    .toList(),
                onChange: (value) {
                  setState(() {
                    selectedEmployee = value;
                  });
                  context
                      .read<AttendanceReportBloc>()
                      .add(ResetAttendanceResult());
                },
              );
            }
            return const Gap(0);
          }),
          if (selectedEmployee != null) const Gap(16),
          if (selectedEmployee != null)
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
        ];
      },
      builder: (context, user) {
        return [ReportResult(type: type)];
      },
    );
  }
}
