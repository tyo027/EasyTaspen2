import 'package:easy/features/attendance/domain/entities/attendance_recap.dart';

class AttendanceRecapModel extends AttendanceRecap {
  AttendanceRecapModel({
    required super.text,
    required super.total,
  });

  static AttendanceRecapModel fromJson(Map<String, dynamic> json) {
    return AttendanceRecapModel(
      text: json["ATEXT"],
      total: json["JUMLAH_HARI"],
    );
  }

  static List<AttendanceRecapModel> fromJsonList(List list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
