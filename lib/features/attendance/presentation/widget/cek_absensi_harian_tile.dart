import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:easy/features/attendance/presentation/widget/attendance_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CekAbsensiHarianTile extends StatelessWidget {
  final List<Attendance> attendances;
  const CekAbsensiHarianTile({
    super.key,
    required this.attendances,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemBuilder: (context, index) =>
          AttendanceTile(attendance: attendances[index]),
      separatorBuilder: (context, index) => const Gap(12),
      itemCount: attendances.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
