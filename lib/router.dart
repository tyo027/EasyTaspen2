import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:easy/features/auth/presentation/page/splash_page.dart';
import 'package:easy/features/home/presentation/pages/home_page.dart';
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
    GoRoute(
      path: SplashPage.route,
      builder: (context, state) => SplashPage(
        redirect: state.uri.queryParameters['redirect'],
      ),
    ),
    GoRoute(
      path: SignInPage.route,
      builder: (context, state) => SignInPage(redirect: state.extra as String?),
    ),
    GoRoute(
      path: HomePage.route,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
