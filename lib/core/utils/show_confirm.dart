import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showConfirm(BuildContext context,
    {required String title,
    required String text,
    required VoidCallback onConfirm}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppPallete.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: AppPallete.textStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            Text(
              text,
              style: AppPallete.textStyle,
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the bottom sheet
                  },
                  child: Text(
                    'Cancel',
                    style: AppPallete.textStyle,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ButtonWidget.danger(
                    "Confirm",
                    onPressed: onConfirm,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}
