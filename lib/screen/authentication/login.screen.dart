// ignore_for_file: use_build_context_synchronously
import 'package:easy/Widget/templatelogo.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/authentication/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget implements LoginView {
  const LoginScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LoginScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Templatelogo(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: BlocProvider(
          create: (context) => LoginBloc(this, context),
          child: Column(
            children: [
              _username(),
              _password(),
              const SizedBox(
                height: 20,
              ),
              _button(),
            ],
          ),
        ),
      ),
    )));
  }

  Widget _username() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(10)),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return TextFormField(
            onChanged: (value) => context
                .read<LoginBloc>()
                .add(LoginUsernameChanged(username: value)),
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Username'),
          );
        },
      ),
    );
  }

  Widget _password() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          // border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(10)),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return TextFormField(
              onChanged: (value) => context
                  .read<LoginBloc>()
                  .add(LoginPasswordChanged(password: value)),
              obscureText: !state.isPasswordShow,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
                suffixIcon: IconButton(
                    icon: Icon(state.isPasswordShow
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginPasswordShowChanged(
                          isPasswordShow: !state.isPasswordShow));
                    }),
              ));
        },
      ),
    );
  }

  Widget _button() {
    return Row(
      children: [
        Flexible(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () async {
                  context.read<LoginBloc>().add(LoginRequestedEvent());
                  // login(isFilled, context, state.userName,
                  //     state.password);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: state.isFilled
                          ? Colors.amber[300]
                          : Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                        style: TextStyle(fontWeight: FontWeight.bold), 'Login'),
                  ),
                ),
              );
            },
          ),
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return SizedBox(
              width: (state is Expired) ? 16 : 0,
            );
          },
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Expired) {
              return GestureDetector(
                onTap: () async {
                  context.read<LoginBloc>().add(LoginRequestedBiometricEvent());
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.amber[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: SvgPicture.asset('assets/svgs/face-id.svg')),
                ),
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }

  @override
  void showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  void hideLoading() {
    navigator.pop();
  }

  @override
  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
