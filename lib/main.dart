import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/themes/app_theme.dart';
import 'package:easy/core/dependencies/dependencies.dart';
import 'package:easy/core/utils/messanging.dart';
import 'package:easy/features/account/presentation/bloc/account_bloc.dart';
import 'package:easy/features/account/presentation/bloc/golongan_bloc.dart';
import 'package:easy/features/account/presentation/bloc/position_bloc.dart';
import 'package:easy/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_report_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/my_location_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/rule_bloc.dart';
import 'package:easy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy/features/home/presentation/bloc/home_bloc.dart';
import 'package:easy/features/idle/presentation/bloc/idle_bloc.dart';
import 'package:easy/features/payslip/presentation/bloc/payslip_bloc.dart';
import 'package:easy/permissions.dart';
import 'package:easy/router.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initializeDateFormatting(
    'id_ID',
  );

  await dotenv.load(fileName: ".env");

  await requestPermissions();

  await initDependencies();
  await Messanging.initialize();

  runApp(MultiBlocProvider(
    providers: [
      // Auth
      BlocProvider(create: (_) => Dependency.get<AppUserCubit>()),
      BlocProvider(create: (_) => Dependency.get<AuthBloc>()),

      // Idle
      BlocProvider(create: (_) => Dependency.get<IdleBloc>()),

      // Account
      BlocProvider(create: (_) => Dependency.get<AccountBloc>()),
      BlocProvider(create: (_) => Dependency.get<PositionBloc>()),
      BlocProvider(create: (_) => Dependency.get<GolonganBloc>()),

      // Home
      BlocProvider(create: (_) => Dependency.get<HomeBloc>()),

      // Attendance
      BlocProvider(create: (_) => Dependency.get<RuleBloc>()),
      BlocProvider(create: (_) => Dependency.get<MyLocationBloc>()),
      BlocProvider(create: (_) => Dependency.get<AttendanceBloc>()),
      BlocProvider(create: (_) => Dependency.get<AttendanceReportBloc>()),

      // Payslip
      BlocProvider(create: (_) => Dependency.get<PayslipBloc>()),

      // Admin
      BlocProvider(create: (_) => Dependency.get<AdminBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Taspen Easy',
      theme: AppTheme.lightTheme,
    );
  }
}
