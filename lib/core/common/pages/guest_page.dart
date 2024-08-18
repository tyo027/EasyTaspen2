import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GuestPage extends StatelessWidget {
  final List<Widget> children;
  final Widget child;
  final bool canScroll;
  const GuestPage({
    super.key,
    this.child = const SizedBox(),
    this.canScroll = true,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomAppBar(),
      body: SafeArea(
        child: canScroll
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: child,
              ),
      ),
    );
  }

  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
      elevation: 0,
      padding: const EdgeInsets.all(12),
      notchMargin: 0,
      color: Colors.white,
      height: kBottomNavigationBarHeight,
      child: Center(
          child: Text(
              "Powered by PT TASPEN(Persero) - ${dotenv.env['APP_VERSION']}")),
    );
  }
}
