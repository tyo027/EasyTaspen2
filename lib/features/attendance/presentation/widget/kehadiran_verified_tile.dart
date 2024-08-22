import 'package:easy/features/attendance/domain/entities/daily_attendance.dart';
import 'package:flutter/material.dart';

class KehadiranVerifiedTile extends StatelessWidget {
  final List<DailyAttendance> attendances;
  const KehadiranVerifiedTile({
    super.key,
    required this.attendances,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: ['Hari', 'Absen', 'Status']
              .map((e) => Padding(
                    padding: EdgeInsets.only(
                      left: e != 'Hari' ? 0 : 32,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      e,
                      textAlign: e != 'Hari' ? TextAlign.center : null,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ))
              .toList(),
        ),
        ...(attendances.asMap().entries.map((e) {
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
                  child:
                      Text("${value.dayTxt} \n${value.lDate} ${value.lTime}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.schkz,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.status,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]);
        }).toList())
      ],
    );
  }
}
