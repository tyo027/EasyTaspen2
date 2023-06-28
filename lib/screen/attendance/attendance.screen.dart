import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:easy/screen/laporan.screen.dart';
import 'package:flutter/material.dart';
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

  Row attendanceMenu(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () =>
              navigator.push(SubmitAttendance.route(SubmitAttendanceType.wfh)),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: SvgPicture.asset("assets/svgs/wfh.svg"),
          ),
        ),
        GestureDetector(
          onTap: () =>
              navigator.push(SubmitAttendance.route(SubmitAttendanceType.wfo)),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: SvgPicture.asset("assets/svgs/wfo.svg"),
          ),
        ),
        GestureDetector(
          onTap: () => navigator.push(LaporanScreen.route()),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: SvgPicture.asset("assets/svgs/laporan.svg"),
          ),
        ),
      ],
    );
  }
}
