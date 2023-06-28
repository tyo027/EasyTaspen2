import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/attendance/attendance.screen.dart';
import 'package:easy/screen/payslip/pay_slip.screen.dart';
import 'package:easy/screen/profile.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const HomeScreen());

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
      canBack: false,
      child: homeMenu(context),
    );
  }

  Widget homeMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => navigator.push(ProfileScreen.route()),
              child: Container(
                margin: const EdgeInsets.all(5),
                child: SvgPicture.asset("assets/svgs/profile.svg"),
              ),
            ),
            GestureDetector(
              onTap: () => navigator.push(AttendanceScreen.route()),
              child: Container(
                margin: const EdgeInsets.all(5),
                child: SvgPicture.asset("assets/svgs/absensi.svg"),
              ),
            ),
            GestureDetector(
              onTap: () => navigator.push(PasySlipScreen.route()),
              child: Container(
                margin: const EdgeInsets.all(5),
                child: SvgPicture.asset("assets/svgs/payslip.svg"),
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text("LogOut Sekarang"),
                  content: const Text("LogOut Sekarang"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("YES"),
                      onPressed: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogoutRequested());
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text("NO"),
                      onPressed: () {
                        navigator.pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Text(
              "Log Out",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ],
    );
  }
}
