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
  final Widget Function(BuildContext context, User user)? bottomWidget;
  final List<Widget> Function(BuildContext context, User user)? stackedWidget;

  final String? title;
  final bool canBack;

  const AuthPage({
    super.key,
    required this.builder,
    this.title,
    this.canBack = true,
    this.bottomWidget,
    this.stackedWidget,
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
              bottomNavigationBar: _bottomAppBar(context, state.user),
              appBar: _appBar(),
              body: SafeArea(
                child: Column(
                  children: [
                    UserInfo(
                      user: state.user,
                    ),
                    if (widget.stackedWidget != null)
                      Container(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 12, left: 24, right: 24),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppPallete.border)),
                        ),
                        child: Column(
                          children: [
                            ...widget.stackedWidget!(context, state.user),
                          ],
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.stackedWidget != null ? 0 : 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [...widget.builder(context, state.user)],
                          ),
                        ),
                      ),
                    ),
                  ],
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
      elevation: 0,
      leadingWidth: 80,
      centerTitle: true,
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

  Widget _bottomAppBar(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: widget.bottomWidget != null
            ? const Border(top: BorderSide(color: AppPallete.border))
            : null,
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.bottomWidget != null) widget.bottomWidget!(context, user),
          if (widget.bottomWidget != null) const Gap(12),
          Text(
            "Powered by PT TASPEN(Persero) - ${dotenv.env['APP_VERSION']}",
            style: const TextStyle(fontSize: 12),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
