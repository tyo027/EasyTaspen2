// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/flash.screen.dart';
import 'package:easy/screen/home.screen.dart';
import 'package:easy/screen/authentication/login.screen.dart';
import 'package:easy/services/fcm.service.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

final navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState!;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppState();
}

class _AppState extends State<AppView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<AuthenticationBloc>().add(AuthenticationCheckRequested());
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  Future<Void?> cekVersion(BuildContext context) async {
    final checker = AppVersionChecker();
    var version = await checker.checkUpdate();

    //Jika ada update
    if (version.canUpdate) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Aplikasi Anda Telah Kadaluarsa, Silahkan Update Aplikasi Anda")));
      await Future.delayed(const Duration(seconds: 5));
      if (version.appURL != null) {
        await launchUrl(Uri.parse(version.appURL!));
      }
    } else {
      context.read<AuthenticationBloc>().add(AuthenticationCheckRequested());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    FcmService.getToken().then((value) => print(value));
    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) => FlashScreen.route(),
      debugShowCheckedModeBanner: false,
      title: "TASPEN - EASY",
      builder: (context, child) => FutureBuilder(
        future: cekVersion(context),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Listener(
            onPointerDown: (event) {
              if (Storage.status()) Storage.activate();
            },
            child: BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    navigator.pushAndRemoveUntil(
                        HomeScreen.route(), (route) => false);
                    break;

                  case AuthenticationStatus.unauthenticated:
                  case AuthenticationStatus.expired:
                    navigator.pushAndRemoveUntil(
                        LoginScreen.route(), (route) => false);
                    break;

                  case AuthenticationStatus.unknown:
                    break;
                }
              },
              child: child,
            ),
          );
        },
      ),
    );
  }
}
