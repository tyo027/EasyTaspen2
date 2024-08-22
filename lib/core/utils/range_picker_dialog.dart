import 'package:flutter/material.dart';

rangePickerDialog(
  BuildContext context, {
  DateTimeRange? initialDateRange,
  required Function(DateTimeRange? selected) onSelected,
}) async {
  final selected = await showDateRangePicker(
    context: context,
    firstDate: DateTime.utc(1980),
    lastDate: DateTime.now(),
    initialDateRange: initialDateRange,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    saveText: "Pilih",
  );

  onSelected(selected);
}
