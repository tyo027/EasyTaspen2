import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/menu_list.dart';

import 'package:easy/features/account/presentation/page/golongan_page.dart';
import 'package:easy/features/account/presentation/page/individu_page.dart';
import 'package:easy/features/account/presentation/page/position_page.dart';
import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/presentation/bloc/rule_bloc.dart';
import 'package:easy/core/common/entities/menu.dart';
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
        context.read<RuleBloc>().add(GetRuleData(
              codeCabang: user.ba,
              nik: user.nik,
            ));
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
                          Navigator.of(context).push(IndividuPage.route());
                        },
                      ),
                    if (state.data.isAllowWFO)
                      Menu(
                        image: 'assets/svgs/wfo.svg',
                        onTap: () {
                          Navigator.of(context).push(PositionPage.route());
                        },
                      ),
                    Menu(
                      image: 'assets/svgs/laporan.svg',
                      onTap: () {
                        Navigator.of(context).push(GolonganPage.route());
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
