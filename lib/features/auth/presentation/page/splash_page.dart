import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/common/pages/guest_page.dart';
import 'package:easy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:easy/features/home/presentation/pages/home_page.dart';
import 'package:easy/features/idle/presentation/bloc/idle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  final String? redirect;
  const SplashPage({
    super.key,
    this.redirect,
  });

  static String route = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(IsUserLogged());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserLoggedOut) {
          context.go(Uri(
            path: SignInPage.route,
            queryParameters: {
              'redirect': widget.redirect,
            },
          ).toString());
        }

        if (state is AppUserLoggedIn) {
          context.read<IdleBloc>().add(CheckIdle());
          if (widget.redirect != null) {
            context.go(widget.redirect!);
          } else {
            context.go(HomePage.route);
          }
        }
      },
      child: GuestPage(
        canScroll: false,
        child: Center(
          child: SvgPicture.asset("assets/svgs/logo.svg"),
        ),
      ),
    );
  }
}
