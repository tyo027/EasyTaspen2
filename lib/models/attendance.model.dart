import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:equatable/equatable.dart';

attendanceModelFromJson(List<dynamic> list) => List<AttendanceModel>.from(
    list.map((json) => AttendanceModel.fromJson(json)));

class AttendanceModel extends Equatable {
  final String attendanceTime;
  final String statusSap;
  final SubmitAttendanceType type;

  const AttendanceModel({
    required this.attendanceTime,
    required this.statusSap,
    required this.type,
  });

  static AttendanceModel fromJson(Map<String, dynamic> json) => AttendanceModel(
      attendanceTime: json['tgl'],
      statusSap: json['sap_flag'],
      type: json['work'] == "wfa"
          ? SubmitAttendanceType.wfa
          : SubmitAttendanceType.wfo);

  @override
  List<Object> get props => [attendanceTime, statusSap, type];
}
