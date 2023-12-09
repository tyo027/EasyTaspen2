import 'package:easy/Widget/menu.template.dart';
import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/screen/golongan.screen.dart';
import 'package:easy/screen/individu.screen.dart';
import 'package:easy/screen/jabatan.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const ProfileScreen());

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
      child: profileScreenMenu(context),
    );
  }

  Widget profileScreenMenu(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return MenuTemplate(
            children: [
              GestureDetector(
                onTap: () => navigator.push(IndividuScreen.route()),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: SvgPicture.asset("assets/svgs/individu.svg"),
                ),
              ),
              if (state.user.isActive)
                GestureDetector(
                  onTap: () => navigator.push(JabatanScreen.route()),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/svgs/jabatan.svg"),
                  ),
                ),
              if (state.user.isActive)
                GestureDetector(
                  onTap: () => navigator.push(GolonganScreen.route()),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/svgs/golongan.svg"),
                  ),
                ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
