import 'package:easy/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.border]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.background,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(24),
      enabledBorder: _border(),
      disabledBorder: _border(),
      focusedBorder: _border(Colors.amber.shade600),
      errorBorder: _border(AppPallete.red),
      focusedErrorBorder: _border(AppPallete.red),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.text,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppPallete.border,
        disabledForegroundColor: AppPallete.text,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dividerColor: AppPallete.border,
  );
}
