import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/features/account/presentation/page/golongan_page.dart';
import 'package:easy/features/account/presentation/page/individu_page.dart';
import 'package:easy/features/account/presentation/page/position_page.dart';
import 'package:easy/features/account/presentation/page/profile_page.dart';
import 'package:easy/features/admin/presentation/pages/admin_page.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/presentation/pages/attendance_page.dart';
import 'package:easy/features/attendance/presentation/pages/attendance_report_page.dart';
import 'package:easy/features/attendance/presentation/pages/submit_attendance_page.dart';
import 'package:easy/features/attendance/presentation/pages/submit_attendance_with_camera_page.dart';
import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:easy/features/auth/presentation/page/splash_page.dart';
import 'package:easy/features/home/presentation/pages/home_page.dart';
import 'package:easy/features/management/presentation/pages/management_page.dart';
import 'package:easy/features/payslip/presentation/pages/payslip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

var router = GoRouter(
  initialLocation: SplashPage.route,
  redirect: (context, state) {
    if (context.read<AppUserCubit>().state is! AppUserLoggedIn &&
        ![SplashPage.route, SignInPage.route].contains(state.fullPath)) {
      return '${SplashPage.route}'
          '?redirect=${state.uri.path}';
    }
    return null;
  },
  observers: [routeObserver],
  routes: [
    // Auth
    GoRoute(
      path: SplashPage.route,
      builder: (context, state) => SplashPage(
        redirect: state.uri.queryParameters['redirect'],
      ),
    ),
    GoRoute(
      path: SignInPage.route,
      builder: (context, state) {
        return SignInPage(
          redirect: state.uri.queryParameters['redirect'],
          canUseBiometric:
              bool.tryParse(state.uri.queryParameters['canUseBiometric'] ?? ''),
        );
      },
    ),

    // Home
    GoRoute(
      path: HomePage.route,
      builder: (context, state) => const HomePage(),
    ),

    // Account
    GoRoute(
      path: GolonganPage.route,
      builder: (context, state) => const GolonganPage(),
    ),
    GoRoute(
      path: IndividuPage.route,
      builder: (context, state) => const IndividuPage(),
    ),
    GoRoute(
      path: PositionPage.route,
      builder: (context, state) => const PositionPage(),
    ),
    GoRoute(
      path: ProfilePage.route,
      builder: (context, state) => const ProfilePage(),
    ),

    // Admin
    GoRoute(
      path: AdminPage.route,
      builder: (context, state) => const AdminPage(),
    ),

    // Attendance
    GoRoute(
      path: AttendancePage.route,
      builder: (context, state) => const AttendancePage(),
    ),
    GoRoute(
      path: AttendanceReportPage.route,
      builder: (context, state) => const AttendanceReportPage(),
    ),
    GoRoute(
      path: SubmitAttendancePage.route,
      builder: (context, state) => SubmitAttendancePage(
        type: state.extra! as AttendanceType,
      ),
    ),
    GoRoute(
      path: SubmitAttendanceWithCameraPage.route,
      builder: (context, state) => SubmitAttendanceWithCameraPage(
        type: state.extra! as AttendanceType,
      ),
    ),

    // Management
    GoRoute(
      path: ManagementPage.route,
      builder: (context, state) => const ManagementPage(),
    ),

    // Payslip
    GoRoute(
      path: PayslipPage.route,
      builder: (context, state) => const PayslipPage(),
    ),
  ],
);
