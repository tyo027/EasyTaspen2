import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Center(
        child:
            SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
      );
    },
  );
}
