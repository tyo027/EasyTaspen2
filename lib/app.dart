import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/flash.screen.dart';
import 'package:easy/screen/home.screen.dart';
import 'package:easy/screen/authentication/login.screen.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

final navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState!;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Permission.notification.request();
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
    context.read<AuthenticationBloc>().add(AuthenticationCheckRequested());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) => FlashScreen.route(),
      debugShowCheckedModeBanner: false,
      title: "TASPEN - EASY",
      builder: (context, child) => Listener(
        onPointerDown: (event) {
          if (Storage.status()) Storage.activate();
        },
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            if (state is Authenticated) {
              navigator.pushAndRemoveUntil(
                  HomeScreen.route(), (route) => false);
              return;
            }

            if (state is UnAuthenticated || state is Expired) {
              navigator.pushAndRemoveUntil(
                  LoginScreen.route(), (route) => false);
              return;
            }

            // if (state is NeedPermissions) {
            //   navigator.pushAndRemoveUntil(
            //       FlashScreen.route(), (route) => false);
            //   showDialog(
            //     context: navigator.context,
            //     useRootNavigator: false,
            //     barrierDismissible: false,
            //     builder: (context) {
            //       return CupertinoAlertDialog(
            //         title: const Text("Saran"),
            //         content: const Text(
            //             "Aktifkan izin aplikasi untuk penggunaan aplikasi secara optimal"),
            //         actions: [
            //           CupertinoDialogAction(
            //             child: const Text("Terimakasih"),
            //             onPressed: () {
            //               // openAppSettings();
            //               navigator.pop();
            //             },
            //           ),
            //         ],
            //       );
            //     },
            //   );

            //   return;
            // }

            if (state is NeedUpdate) {
              navigator.pushAndRemoveUntil(
                  FlashScreen.route(), (route) => false);
              showDialog(
                context: navigator.context,
                useRootNavigator: false,
                barrierDismissible: false,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Update Aplikasi"),
                    content: Text(
                        "Aplikasi Anda Telah Kadaluarsa, Silahkan Update Aplikasi ke versi ${state.version.newVersion}"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("Update sekarang"),
                        onPressed: () {
                          if (state.version.appURL != null) {
                            launchUrl(Uri.parse(state.version.appURL!));
                            return;
                          }

                          navigator.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: child,
        ),
      ),
    );
  }
}
