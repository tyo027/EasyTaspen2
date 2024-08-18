import 'package:flutter/material.dart';

class AppPallete {
  static const Color primary = Color(0xFF5CB0D2);
  static const Color secondary = Color(0xFFCEEE4F);
  static const Color red = Color(0xFFE74C3C);

  static const Color text = Color(0xFF1A1E0B);
  static const Color textGray = Color(0xFFA5B0BF);

  static const Color background = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFECECEC);

  static const Color shadow = Color.fromRGBO(27, 27, 77, .04);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: shadow, blurRadius: 45, offset: Offset(1, 2)),
  ];

  static List<BoxShadow> dialogShadow = [
    BoxShadow(
        color: shadow.withOpacity(.1),
        blurRadius: 45,
        offset: const Offset(0, 4)),
  ];

  static TextStyle textStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: AppPallete.text,
  );
}
