import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/menu_list.dart';
import 'package:easy/features/account/presentation/page/golongan_page.dart';
import 'package:easy/features/account/presentation/page/individu_page.dart';
import 'package:easy/features/account/presentation/page/position_page.dart';
import 'package:easy/core/common/entities/menu.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const ProfilePage());

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Profil",
      builder: (context, user) {
        return [
          MenuList(
            items: [
              Menu(
                image: 'assets/svgs/individu.svg',
                onTap: () {
                  Navigator.of(context).push(IndividuPage.route());
                },
              ),
              Menu(
                image: 'assets/svgs/jabatan.svg',
                onTap: () {
                  Navigator.of(context).push(PositionPage.route());
                },
              ),
              Menu(
                image: 'assets/svgs/golongan.svg',
                onTap: () {
                  Navigator.of(context).push(GolonganPage.route());
                },
              ),
            ],
          )
        ];
      },
    );
  }
}
