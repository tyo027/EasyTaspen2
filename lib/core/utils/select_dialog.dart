import 'package:flutter/material.dart';

class SelectDialogItem {
  final String text;
  final String value;

  SelectDialogItem({required this.text, required this.value});
}

selectDialog(
  BuildContext context, {
  required String title,
  required List<SelectDialogItem> items,
  required void Function(String? selected) onSelected,
}) async {
  final response = await showDialog<String?>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(title),
      children: items
          .map(
            (item) => SimpleDialogOption(
              child: Text(item.text),
              onPressed: () {
                Navigator.pop(context, item.value);
              },
            ),
          )
          .toList(),
    ),
  );

  onSelected(response);
}
