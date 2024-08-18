import 'package:easy/core/common/pages/auth_page.dart';
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
      builder: (context, user) {
        return [
          Text(user.nama),
        ];
      },
    );
  }
}
