import 'package:easy/features/attendance/domain/entities/attendance.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';

class AttendanceModel extends Attendance {
  AttendanceModel({
    required super.date,
    required super.sapFlag,
    required super.type,
  });

  static AttendanceModel fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: DateTime.parse(json["tgl"]),
      sapFlag: json["sap_flag"],
      type: AttendanceType.values.firstWhere(
        (type) =>
            type.name.toUpperCase() ==
            json['keterangan'].toString().toUpperCase(),
      ),
    );
  }

  static List<AttendanceModel> fromJsonList(List list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
