import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/common/entities/user.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:easy/features/account/presentation/widget/user_info.dart';
import 'package:easy/features/auth/presentation/page/sign_in_page.dart';
import 'package:easy/features/idle/presentation/bloc/idle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  final List<Widget> Function(BuildContext context, User user) builder;

  final String? title;
  final bool canBack;

  const AuthPage({
    super.key,
    required this.builder,
    this.title,
    this.canBack = true,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    context.read<IdleBloc>().add(CheckIdle());
  }

  void _onUserActivity(BuildContext context) {
    context.read<IdleBloc>().add(UserActivityDetected());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (_) => _onUserActivity(context),
      onTap: () => _onUserActivity(context),
      child: BlocConsumer<AppUserCubit, AppUserState>(
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
              appBar: _appBar(),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocConsumer<IdleBloc, IdleState>(
                          listener: (context, state) {
                            if (state is IdleExpired) {
                              context.go(Uri(
                                path: SignInPage.route,
                                queryParameters: {'canUseBiometric': 'true'},
                              ).toString());
                            }
                          },
                          builder: (context, idleState) {
                            return const Gap(0);
                          },
                        ),
                        UserInfo(
                          user: state.user,
                        ),
                        ...widget.builder(context, state.user)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: AppPallete.shadow.withOpacity(.4),
      leadingWidth: 80,
      leading: widget.canBack
          ? Container(
              height: 32,
              width: 32,
              margin: const EdgeInsets.only(left: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  foregroundColor: AppPallete.text,
                  elevation: 0,
                  enableFeedback: false,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),
            )
          : null,
      title: widget.title != null
          ? Text(
              widget.title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
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
          "Powered by PT TASPEN(Persero) - ${dotenv.env['APP_VERSION']}",
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
