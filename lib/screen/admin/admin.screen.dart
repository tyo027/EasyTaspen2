import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/admin/bloc/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminScreen extends StatelessWidget implements AdminView {
  const AdminScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const AdminScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: UserInfoTemplate(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: BlocProvider(
          create: (context) => AdminBloc(this, context),
          child: Column(
            children: [
              _username(),
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
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          return TextFormField(
            onChanged: (value) =>
                context.read<AdminBloc>().add(AdminChanged(username: value)),
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Username'),
          );
        },
      ),
    );
  }

  Widget _button() {
    return Row(
      children: [
        Flexible(
          child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () async {
                  context.read<AdminBloc>().add(DeleteUnChanged());
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                        'Buka Akses'),
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
