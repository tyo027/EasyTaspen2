import 'package:equatable/equatable.dart';

rekapKehadiranClockModelFromJson(List<dynamic> list) =>
    List<RekapKehadiranClockModel>.from(
        list.map((json) => RekapKehadiranClockModel.fromJson(json)));

class RekapKehadiranClockModel extends Equatable {
  final String DAYTXT;
  final String LDATE;
  final String LTIME;
  final String SATZA;
  final String SCHKZ;
  final String STATUS;

  const RekapKehadiranClockModel({
    required this.DAYTXT,
    required this.LDATE,
    required this.LTIME,
    required this.SATZA,
    required this.SCHKZ,
    required this.STATUS,
  });

  static RekapKehadiranClockModel fromJson(Map<String, dynamic> json) =>
      RekapKehadiranClockModel(
        DAYTXT: json['DAYTXT'],
        LDATE: json['LDATE'],
        LTIME: json['LTIME'],
        SATZA: json['SATZA'],
        SCHKZ: json['SCHKZ'],
        STATUS: json['STATUS'],
      );

  @override
  List<Object> get props => [
        DAYTXT,
        LDATE,
        LTIME,
        SATZA,
        SCHKZ,
        STATUS,
      ];
}
