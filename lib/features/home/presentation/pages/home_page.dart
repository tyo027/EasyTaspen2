import 'package:easy/core/common/entities/user.dart';
import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/svg_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:easy/features/account/presentation/page/profile_page.dart';
import 'package:easy/features/home/domain/entities/menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Home",
      canBack: false,
      builder: (context, user) {
        final menuList = menus(context, user);
        return [
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              final menu = menuList[index];
              return ElevatedButton(
                onPressed: menu.onTap,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: AppPallete.shadow),
                child: SvgWidget(
                  menu.image,
                  useDefaultColor: true,
                  size: double.infinity,
                ),
              );
            },
          )
        ];
      },
    );
  }

  List<Menu> menus(BuildContext context, User user) => [
        if (user.canAccess)
          Menu(
            image: 'assets/svgs/profile.svg',
            onTap: () {
              Navigator.of(context).push(ProfilePage.route());
            },
          ),
        if (user.canAccess)
          Menu(
            image: 'assets/svgs/absensi.svg',
            onTap: () {},
          ),
        if (user.canAccess)
          Menu(
            image: 'assets/svgs/payslip.svg',
            onTap: () {},
          ),
      ];
}
