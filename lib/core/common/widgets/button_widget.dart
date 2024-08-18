import 'package:easy/core/common/widgets/svg_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ButtonWidget {
  static ButtonComponent primary(
    String text, {
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return ButtonComponent(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? Colors.amber.shade300,
      foregroundColor: foregroundColor ?? AppPallete.text,
      padding: padding,
    );
  }

  static ButtonComponent small(
    String text, {
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return ButtonComponent(
      text: text,
      fonstSize: 12,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppPallete.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    );
  }

  static ButtonComponent secondary(String text) {
    return ButtonComponent(
      text: text,
      backgroundColor: AppPallete.secondary,
      onPressed: () {},
    );
  }

  static ButtonComponent danger(
    String text, {
    required VoidCallback? onPressed,
  }) {
    return ButtonComponent(
      text: text,
      onPressed: onPressed,
      backgroundColor: AppPallete.red,
    );
  }

  static ButtonComponent withIcon(
    String text,
    String icon, {
    required VoidCallback? onPressed,
    Color? borderColor,
  }) {
    return ButtonComponent(
      text: text,
      icon: icon,
      backgroundColor: Colors.white,
      foregroundColor: AppPallete.text,
      onPressed: onPressed,
      borderColor: borderColor,
    );
  }

  static ButtonIcon icon(
    String icon, {
    required VoidCallback? onPressed,
  }) {
    return ButtonIcon(
      onPressed: onPressed,
      icon: icon,
    );
  }
}

class ButtonIcon extends StatelessWidget {
  final String icon;
  final Color? iconColor;

  final VoidCallback? onPressed;

  const ButtonIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: SvgWidget(
        icon,
        color: iconColor ?? Colors.amber.shade300,
      ),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppPallete.text,
          foregroundColor: Colors.amber.shade300,
          overlayColor: AppPallete.text,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size.square(44)),
    );
  }
}

class ButtonComponent extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;

  final String text;

  final String? icon;
  final Color? iconColor;

  final VoidCallback? onPressed;

  final Color? borderColor;

  final MainAxisAlignment alignment;

  final EdgeInsetsGeometry? padding;
  final double? fonstSize;

  const ButtonComponent({
    super.key,
    this.backgroundColor = AppPallete.primary,
    this.foregroundColor = Colors.white,
    this.text = '',
    required this.onPressed,
    this.icon,
    this.iconColor,
    this.borderColor,
    this.alignment = MainAxisAlignment.center,
    this.padding,
    this.fonstSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null
          ? () {
              FocusScope.of(context).unfocus();
              onPressed!();
            }
          : null,
      style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          elevation: 12,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderColor != null
                ? BorderSide(
                    color: borderColor!,
                  )
                : BorderSide.none,
          ),
          enableFeedback: false,
          shadowColor: AppPallete.shadow,
          textStyle: AppPallete.textStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: fonstSize ?? 14,
          ),
          minimumSize: const Size.fromHeight(48)),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          if (icon != null)
            SvgWidget(
              icon!,
              color: iconColor ?? foregroundColor,
            ),
          if (icon != null) const Gap(8),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              text,
              textAlign: icon != null ? TextAlign.left : TextAlign.center,
              softWrap: true,
              style: AppPallete.textStyle.copyWith(
                // overflow: TextOverflow.ellipsis,
                fontSize: fonstSize ?? 14,
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
