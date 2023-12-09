import 'package:easy/Widget/menu.template.dart';
import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:easy/screen/laporanscreen/laporans.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const AttendanceScreen());

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
      child: attendanceMenu(context),
    );
  }

  Widget attendanceMenu(BuildContext context) {
    return MenuTemplate(children: [
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return GestureDetector(
              onTap: () {
                if (state.user.allowWFA) {
                  navigator
                      .push(SubmitAttendance.route(SubmitAttendanceType.wfa));
                }
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: filterSvg((state.user.allowWFA), "assets/svgs/wfa.svg"),
              ),
            );
          }
          return Container();
        },
      ),
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return GestureDetector(
              onTap: () {
                if (state.user.allowWFO) {
                  navigator
                      .push(SubmitAttendance.route(SubmitAttendanceType.wfo));
                }
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: filterSvg(state.user.allowWFO, "assets/svgs/wfo.svg"),
              ),
            );
          }
          return Container();
        },
      ),
      GestureDetector(
        onTap: () => navigator.push(LaporansScreen.route()),
        child: Container(
          margin: const EdgeInsets.all(5),
          child: SvgPicture.asset("assets/svgs/laporan.svg"),
        ),
      ),
    ]);
  }

  Widget filterSvg(bool isActive, String asset) {
    return !isActive
        ? ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: SvgPicture.asset(
              asset,
            ))
        : SvgPicture.asset(asset);
  }
}
