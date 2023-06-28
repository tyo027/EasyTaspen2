import 'package:easy/Widget/templatecopyright.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Templatelogo extends StatelessWidget {
  const Templatelogo({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Templatecopyright(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/svgs/logo.svg"),
          if (child != null) child!
        ],
      ),
    );
  }
}
