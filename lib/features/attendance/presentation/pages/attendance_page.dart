import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/menu_list.dart';

import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/presentation/bloc/rule_bloc.dart';
import 'package:easy/core/common/entities/menu.dart';
import 'package:easy/features/attendance/presentation/pages/attendance_report_page.dart';
import 'package:easy/features/attendance/presentation/pages/submit_attendance_page.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const AttendancePage());

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Presensi",
      builder: (context, user) {
        final ruleBloc = context.read<RuleBloc>();
        if (ruleBloc.state is! SuccessState) {
          ruleBloc.add(
            GetRuleData(
              codeCabang: user.ba,
              nik: user.nik,
            ),
          );
        }
        return [
          BaseConsumer<RuleBloc, Rule>(
            builder: (context, state) {
              if (state is SuccessState<Rule>) {
                return MenuList(
                  items: [
                    if (state.data.isAllowWFH)
                      Menu(
                        image: 'assets/svgs/wfa.svg',
                        onTap: () {
                          Navigator.of(context).push(
                              SubmitAttendancePage.route(AttendanceType.wfa));
                        },
                      ),
                    if (state.data.isAllowWFO)
                      Menu(
                        image: 'assets/svgs/wfo.svg',
                        onTap: () {
                          Navigator.of(context).push(
                              SubmitAttendancePage.route(AttendanceType.wfo));
                        },
                      ),
                    Menu(
                      image: 'assets/svgs/laporan.svg',
                      onTap: () {
                        Navigator.of(context)
                            .push(AttendanceReportPage.route());
                      },
                    ),
                  ],
                );
              }
              return const Gap(0);
            },
          )
        ];
      },
    );
  }
}
