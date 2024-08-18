import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/themes/app_theme.dart';
import 'package:easy/core/dependencies/dependencies.dart';
import 'package:easy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy/router.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();

  // await Storage.initialize();

  // cameraDescriptions = await availableCameras();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await FcmService.initialize();
  // await AlarmService.init();

  runApp(MultiBlocProvider(
    providers: [
      // Auth
      BlocProvider(create: (_) => Dependency.get<AppUserCubit>()),
      BlocProvider(create: (_) => Dependency.get<AuthBloc>()),
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
