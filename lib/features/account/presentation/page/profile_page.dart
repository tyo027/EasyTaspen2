import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/menu_list.dart';
import 'package:easy/features/account/presentation/page/golongan_page.dart';
import 'package:easy/features/account/presentation/page/individu_page.dart';
import 'package:easy/features/account/presentation/page/position_page.dart';
import 'package:easy/core/common/entities/menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static String route = '/account';

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
                  context.push(IndividuPage.route);
                },
              ),
              Menu(
                image: 'assets/svgs/jabatan.svg',
                onTap: () {
                  context.push(PositionPage.route);
                },
              ),
              Menu(
                image: 'assets/svgs/golongan.svg',
                onTap: () {
                  context.push(GolonganPage.route);
                },
              ),
            ],
          )
        ];
      },
    );
  }
}
