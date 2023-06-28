import 'package:easy/Widget/templatelogo.dart';
import 'package:flutter/material.dart';

class FlashScreen extends StatelessWidget {
  const FlashScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const FlashScreen());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: Templatelogo()));
  }
}
