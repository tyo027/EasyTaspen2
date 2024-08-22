import 'package:easy/features/attendance/domain/entities/attendance_recap.dart';
import 'package:flutter/material.dart';

class RekapKehadiranTile extends StatelessWidget {
  final List<AttendanceRecap> recaps;

  const RekapKehadiranTile({super.key, required this.recaps});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: ['Keterangan', 'Jumlah']
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(
                    left: e == 'Jumlah' ? 0 : 32,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    e,
                    textAlign: e == 'Jumlah' ? TextAlign.center : null,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
              .toList(),
        ),
        ...(recaps
            .where((item) => item.text.isNotEmpty)
            .toList()
            .asMap()
            .entries
            .map((e) {
          var value = e.value;
          return TableRow(
              decoration: e.key % 2 == 1
                  ? BoxDecoration(color: Colors.grey[100])
                  : null,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(value.text),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.total,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]);
        }).toList())
      ],
    );
  }
}
