import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/menu_list.dart';
import 'package:easy/features/account/presentation/page/profile_page.dart';
import 'package:easy/features/admin/presentation/pages/admin_page.dart';
import 'package:easy/features/attendance/presentation/pages/attendance_page.dart';
import 'package:easy/core/common/entities/menu.dart';
import 'package:easy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy/features/home/domain/entities/home.dart';
import 'package:easy/features/home/presentation/bloc/home_bloc.dart';
import 'package:easy/features/management/presentation/pages/management_page.dart';
import 'package:easy/features/payslip/presentation/pages/payslip_page.dart';
import 'package:fca/fca.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Home",
      canBack: false,
      builder: (context, user) {
        final homeBloc = context.read<HomeBloc>();
        if (homeBloc.state is! SuccessState) {
          homeBloc.add(LoadHomeData(nik: user.nik));
        }

        return [
          BaseConsumer<HomeBloc, Home>(
            builder: (context, state) {
              if (state is SuccessState<Home>) {
                return MenuList(
                  items: [
                    if (user.canAccess)
                      Menu(
                        image: 'assets/svgs/profile.svg',
                        onTap: () {
                          context.push(ProfilePage.route);
                        },
                      ),
                    if (user.canAccess)
                      Menu(
                        image: 'assets/svgs/absensi.svg',
                        onTap: () {
                          context.push(AttendancePage.route);
                        },
                      ),
                    if (state.data.hasEmployee)
                      Menu(
                        image: 'assets/svgs/manajemen.svg',
                        onTap: () {
                          context.push(ManagementPage.route);
                        },
                      ),
                    Menu(
                      image: 'assets/svgs/payslip.svg',
                      onTap: () {
                        context.push(PayslipPage.route);
                      },
                    ),
                    if (state.data.isAdmin)
                      Menu(
                        image: 'assets/svgs/admin.svg',
                        onTap: () {
                          context.push(AdminPage.route);
                        },
                      ),
                    Menu(
                      image: 'assets/svgs/logout.svg',
                      onTap: () {
                        _logout(context);
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

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Log out sekarang?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("YA"),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutNow());
              },
            ),
            CupertinoDialogAction(
              child: const Text("TIDAK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
