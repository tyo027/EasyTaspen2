import 'package:easy/core/common/entities/user.dart';
import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/core/common/pages/guest_page.dart';
import 'package:easy/core/common/widgets/text_field_widget.dart';
import 'package:easy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easy/features/home/presentation/pages/home_page.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  final String? redirect;
  const SignInPage({
    super.key,
    this.redirect,
  });

  static String route = '/auth/sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return GuestPage(
      canScroll: false,
      child: BaseConsumer<AuthBloc, User>(
        onSuccess: (data) {
          context.go(HomePage.route);
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                "assets/svgs/logo.svg",
                width: 150,
              ),
              const Gap(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: _form(),
              )
            ],
          );
        },
      ),
    );
  }

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Form _form() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFieldWidget(
            'Username',
            controller: usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) return "Username kosong!";
              return null;
            },
          ),
          const Gap(20),
          TextFieldWidget(
            'Password',
            isPassword: true,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) return "Password kosong!";
              return null;
            },
          ),
          const Gap(32),
          Row(
            children: [
              Flexible(
                child: ButtonWidget.primary(
                  "Login",
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    context.read<AuthBloc>().add(
                          Authenticate(
                            username: usernameController.text,
                            password: passwordController.text,
                          ),
                        );
                  },
                ),
              ),
              const Gap(12),
              ButtonWidget.icon(
                'assets/svgs/face-id.svg',
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
