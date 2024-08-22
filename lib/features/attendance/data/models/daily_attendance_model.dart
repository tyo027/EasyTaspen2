import 'package:easy/features/attendance/domain/entities/daily_attendance.dart';

class DailyAttendanceModel extends DailyAttendance {
  DailyAttendanceModel({
    required super.dayTxt,
    required super.lDate,
    required super.lTime,
    required super.satza,
    required super.schkz,
    required super.status,
  });

  static DailyAttendanceModel fromJson(Map<String, dynamic> json) {
    return DailyAttendanceModel(
      dayTxt: json["DAYTXT"],
      lDate: json["LDATE"],
      lTime: json["LTIME"],
      satza: json["SATZA"],
      schkz: json["SCHKZ"],
      status: json["STATUS"],
    );
  }

  static List<DailyAttendanceModel> fromJsonList(List list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
