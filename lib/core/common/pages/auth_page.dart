import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/common/entities/user.dart';
import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatelessWidget {
  final List<Widget> Function(BuildContext context, User user) builder;
  final bool canBack;

  const AuthPage({
    super.key,
    required this.builder,
    this.canBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is! AppUserLoggedIn) {
          context.go(SignInPage.route);
        }
      },
      builder: (context, state) {
        if (state is AppUserLoggedIn) {
          return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: _bottomAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: builder(context, state.user),
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
      elevation: 0,
      padding: const EdgeInsets.all(12),
      notchMargin: 0,
      color: Colors.white,
      height: kBottomNavigationBarHeight,
      child: Center(
          child: Text(
              "Powered by PT TASPEN(Persero) - ${dotenv.env['APP_VERSION']}")),
    );
  }
}
