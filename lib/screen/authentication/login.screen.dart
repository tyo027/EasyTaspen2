// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:device_uuid/device_uuid.dart';
import 'package:easy/Widget/templatelogo.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/location.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/authentication.repository.dart';
import 'package:easy/repositories/device.repository.dart';
import 'package:easy/repositories/profile.repository.dart';
import 'package:easy/screen/authentication/bloc/login_bloc.dart';
import 'package:easy/screen/authentication/register.screen.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LoginScreen());

  void login(
    bool isFilled,
    BuildContext context,
    String username,
    String password,
  ) async {
    if (isFilled) {
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
      var auth = await DeviceRepository().login(
          password: password, username: username.toLowerCase(), uuid: uuid);
      if (auth.status) {
        if (!auth.active) {
          var user = UserModel(
              ba: username,
              jabatan: auth.jabatan,
              nama: auth.fullname,
              nik: "-",
              gender: auth.gender,
              unitkerja: auth.unitKerja,
              isActive: false);

          var location = const LocationModel(
              long: 106.86181245916899, lat: -6.173374841022986);

          await Storage.write("user", json.encode(user.toJson()));
          await Storage.write("location", json.encode(location.toJson()));
          context.read<AuthenticationBloc>().add(AuthenticationLoginRequested(
                user: user,
              ));
          return;
        }

        var location =
            await AuthenticationRepository().getCabangLocation(auth.ba!);
        if (location == null) {
          navigator.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Tidak Dapat Menemukan Area Kantor")));
          return;
        }
        await Storage.write("token", auth.token);

        var userProfile = await ProfileRepository().getProfile(nik: auth.nik);
        if (userProfile == null) {
          navigator.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Data Tidak Ditemukan, Coba beberapa saat lagi")));
          await Storage.remove("token");
          return;
        }

        var user = UserModel(
            nik: auth.nik,
            nama: auth.fullname,
            jabatan: auth.jabatan,
            ba: auth.ba,
            unitkerja: auth.unitKerja,
            isActive: true,
            gender: userProfile.gender);

        await Storage.write("user", json.encode(user.toJson()));
        await Storage.write("location", json.encode(location.toJson()));
        context.read<AuthenticationBloc>().add(AuthenticationLoginRequested(
              user: user,
            ));
        return;
      }

      navigator.pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(auth.message)));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Templatelogo(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: BlocProvider(
          create: (context) => LoginBloc(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(20)),
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(LoginUserNameChanged(userName: value)),
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
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextFormField(
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(password: value)),
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
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  var isFilled = (state.userName != "" && state.password != "");

                  return GestureDetector(
                    onTap: () async {
                      login(isFilled, context, state.userName, state.password);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: isFilled ? Colors.amber[300] : Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Login'),
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
                      text: "Dont have an account? ",
                      style: TextStyle(color: Colors.black54)),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigator.pushAndRemoveUntil(
                              RegisterScreen.route(), (route) => false);
                        },
                      text: "Register",
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
