import 'package:easy/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  final String url;
  final Color? color;
  final double? size;
  final bool? useDefaultColor;

  const SvgWidget(
    this.url, {
    super.key,
    this.color,
    this.size,
    this.useDefaultColor,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      url,
      width: size ?? 24,
      height: size ?? 24,
      colorFilter: useDefaultColor ?? false
          ? null
          : ColorFilter.mode(color ?? AppPallete.text, BlendMode.srcIn),
    );
  }
}
