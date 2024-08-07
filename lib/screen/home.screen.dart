import 'package:easy/Widget/menu.template.dart';
import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/admin/admin.screen.dart';
import 'package:easy/screen/attendance/attendance.screen.dart';
import 'package:easy/screen/manajemenscreen/manajemen.screen.dart';
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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          var canAccess = !["BOD", "BOC", "SBOC"].contains(state.user.perty);
          print(state.user.toJson());
          return Column(
            children: [
              MenuTemplate(children: [
                if (canAccess)
                  GestureDetector(
                    onTap: () => navigator.push(ProfileScreen.route()),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: SvgPicture.asset("assets/svgs/profile.svg"),
                    ),
                  ),
                if (canAccess)
                  GestureDetector(
                    onTap: () => navigator.push(AttendanceScreen.route()),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: SvgPicture.asset("assets/svgs/absensi.svg"),
                    ),
                  ),
                GestureDetector(
                  onTap: () => navigator.push(ManajemenScreen.route()),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/svgs/manajemen.svg"),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigator.push(PasySlipScreen.route()),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/svgs/payslip.svg"),
                  ),
                ),
                if (state.user.isAdmin)
                  GestureDetector(
                    onTap: () => navigator.push(AdminScreen.route()),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: SvgPicture.asset("assets/svgs/admin.svg"),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Log Out Sekarang"),
                          content: const Text("Log Out Sekarang"),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("YA"),
                              onPressed: () {
                                context
                                    .read<AuthenticationBloc>()
                                    .add(AuthenticationLogoutRequested());
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text("TIDAK"),
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
                    margin: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/svgs/logout.svg"),
                  ),
                ),
              ]),
              const Spacer(),
              // GestureDetector(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) {
              //         return CupertinoAlertDialog(
              //           title: const Text("Log Out Sekarang"),
              //           content: const Text("Log Out Sekarang"),
              //           actions: [
              //             CupertinoDialogAction(
              //               child: const Text("YA"),
              //               onPressed: () {
              //                 context
              //                     .read<AuthenticationBloc>()
              //                     .add(AuthenticationLogoutRequested());
              //               },
              //             ),
              //             CupertinoDialogAction(
              //               child: const Text("TIDAK"),
              //               onPressed: () {
              //                 navigator.pop();
              //               },
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.all(20),
              //     margin:
              //         const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         color: Colors.red.shade800,
              //         borderRadius: BorderRadius.circular(20)),
              //     child: const Center(
              //         child: Text(
              //       "Log Out",
              //       style: TextStyle(
              //           color: Colors.white, fontWeight: FontWeight.bold),
              //     )),
              //   ),
              // ),
            ],
          );
        }
        return Container();
      },
    );
    // return Column(
    //   children: [
    //     BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //       builder: (context, state) {
    //         if (state is Authenticated &&
    //             (state.user.perty == "BOD" ||
    //                 state.user.perty == "BOC" ||
    //                 state.user.perty == "SBOC")) {
    //           return Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               if (state.user.isActive)
    //
    //             ],
    //           );
    //         }
    //         if (state is Authenticated &&
    //             (state.user.perty != "BOD" ||
    //                 state.user.perty != "BOC" ||
    //                 state.user.perty != "SBOC")) {
    //           return Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               GestureDetector(
    //                 onTap: () => navigator.push(ProfileScreen.route()),
    //                 child: Container(
    //                   margin: const EdgeInsets.all(5),
    //                   child: SvgPicture.asset("assets/svgs/profile.svg"),
    //                 ),
    //               ),
    //               if (state.user.isActive)
    //                 GestureDetector(
    //                   onTap: () => navigator.push(AttendanceScreen.route()),
    //                   child: Container(
    //                     margin: const EdgeInsets.all(5),
    //                     child: SvgPicture.asset("assets/svgs/absensi.svg"),
    //                   ),
    //                 ),
    //               if (state.user.isActive)
    //                 GestureDetector(
    //                   onTap: () => navigator.push(PasySlipScreen.route()),
    //                   child: Container(
    //                     margin: const EdgeInsets.all(5),
    //                     child: SvgPicture.asset("assets/svgs/payslip.svg"),
    //                   ),
    //                 ),
    //             ],
    //           );
    //         }
    //         return Container();
    //       },
    //     ),

    //     // Admin
    //     BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //       builder: (context, state) {
    //         if (state is Authenticated && (state.user.nik == "4161")) {
    //           return Row(
    //             // crossAxisAlignment: CrossAxisAlignment.start,
    //             // mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //
    //             ],
    //           );
    //         }
    //         return Container();
    //       },
    //     ),

    //     // BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //     //   builder: (context, state) {
    //     //     if (state.user != null) {
    //     //       return Row(
    //     //         crossAxisAlignment: CrossAxisAlignment.center,
    //     //         mainAxisAlignment: MainAxisAlignment.center,
    //     //         children: [
    //     //           GestureDetector(
    //     //             onTap: () => navigator.push(NotifScreen.route()),
    //     //             child: Container(
    //     //               margin: const EdgeInsets.all(5),
    //     //               child: SvgPicture.asset("assets/svgs/profile.svg"),
    //     //             ),
    //     //           ),
    //     //         ],
    //     //       );
    //     //     }
    //     //     return Container();
    //     //   },
    //     // ),
    //
    //   ],
    // );
  }
}
