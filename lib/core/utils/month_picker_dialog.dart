import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

monthPickerDialog(
  BuildContext context, {
  required Function(DateTime? selectedMonth) onSelected,
  DateTime? initialDate,
  DateTime? lastDate,
}) async {
  final selectedMonth = await showMonthPicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime.now(),
    cancelWidget: const Text(
      "Batal",
      style: TextStyle(color: Colors.black38),
    ),
    confirmWidget: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(10)),
      child: const Text(
        "Pilih",
        style: TextStyle(color: Colors.black),
      ),
    ),
    monthPickerDialogSettings: const MonthPickerDialogSettings(
      dialogSettings: PickerDialogSettings(
        locale: Locale('id_ID'),
        dialogBackgroundColor: Colors.white,
      ),
      headerSettings: PickerHeaderSettings(
        headerBackgroundColor: Colors.amber,
        headerIconsColor: Colors.black,
        headerCurrentPageTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headerSelectedIntervalTextStyle: TextStyle(),
      ),
      buttonsSettings: PickerButtonsSettings(
        selectedMonthBackgroundColor: Colors.black,
        selectedDateRadius: 7,
        unselectedMonthsTextColor: Colors.black,
      ),
    ),
  );

  onSelected(selectedMonth);
}
