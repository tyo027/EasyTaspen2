import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceTile extends StatelessWidget {
  final Attendance attendance;
  const AttendanceTile({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(
                "Waktu Absen: ${DateFormat('dd MMM yyyy HH:mm WIB', 'id_ID').format(attendance.date)}"),
            Text("Status SAP: ${attendance.sapFlag}"),
            Text("Absensi: ${attendance.type.name.toUpperCase()}")
          ],
        ));
  }
}
