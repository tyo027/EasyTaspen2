// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

rekapKehadiranHarianModelFromJson(List<dynamic> list) =>
    List<RekapKehadiranHarianModel>.from(
        list.map((json) => RekapKehadiranHarianModel.fromJson(json)));

class RekapKehadiranHarianModel extends Equatable {
  final String DAYTXT;
  final String LDATE;
  final String LTIME;
  final String SATZA;
  final String SCHKZ;
  final String STATUS;

  const RekapKehadiranHarianModel({
    required this.DAYTXT,
    required this.LDATE,
    required this.LTIME,
    required this.SATZA,
    required this.SCHKZ,
    required this.STATUS,
  });

  static RekapKehadiranHarianModel fromJson(Map<String, dynamic> json) =>
      RekapKehadiranHarianModel(
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
