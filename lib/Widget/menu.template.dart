import 'package:flutter/material.dart';

class MenuTemplate extends StatelessWidget {
  final List<Widget> children;

  const MenuTemplate({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var childrens =
        children.length == 1 ? [Container(), ...children] : children;
    return GridView.custom(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 35),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 1),
        childrenDelegate: SliverChildListDelegate(childrens));
  }
}
