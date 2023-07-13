// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:device_uuid/device_uuid.dart';
import 'package:easy/Widget/templatelogo.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/location.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/device.repository.dart';
import 'package:easy/screen/authentication/bloc/register_bloc.dart';
import 'package:easy/screen/authentication/login.screen.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const RegisterScreen());

  void register(bool isFilled, BuildContext context, String username,
      String password, String fullname) async {
    if (!isFilled) return;

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
    var uuid = await DeviceUuid().getUUID();
    if (uuid == null) {
      navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal Mendapatkan DeviceID")));
      return;
    }

    var registeredUser = await DeviceRepository().register(
        fullname: fullname, userName: username, password: password, uuid: uuid);

    if (registeredUser != null) {
      navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal register, $registeredUser")));
      return;
    }

    var user = UserModel(
        ba: username,
        jabatan: "-",
        nama: fullname,
        nik: "-",
        unitkerja: "-",
        isActive: false);

    var location =
        const LocationModel(long: 106.86181245916899, lat: -6.173374841022986);

    await Storage.write("user", json.encode(user.toJson()));
    await Storage.write("location", json.encode(location.toJson()));
    context.read<AuthenticationBloc>().add(AuthenticationLoginRequested(
          user: user,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Templatelogo(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: BlocProvider(
          create: (context) => RegisterBloc(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(20)),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterFullnameChanged(fullname: value)),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Full Name'),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(20)),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterUserNameChanged(userName: value)),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Username'),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(20)),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterPasswordChanged(password: value)),
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Password'),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  var isFilled = (state.userName != "" &&
                      state.password != "" &&
                      state.fullname != "");

                  return GestureDetector(
                    onTap: () async {
                      register(isFilled, context, state.userName,
                          state.password, state.fullname);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: isFilled ? Colors.amber[300] : Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Register'),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                children: [
                  const TextSpan(
                      text: "I have an account? ",
                      style: TextStyle(color: Colors.black54)),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigator.pushAndRemoveUntil(
                              LoginScreen.route(), (route) => false);
                        },
                      text: "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[800])),
                ],
              ))
            ],
          ),
        ),
      ),
    )));
  }
}
