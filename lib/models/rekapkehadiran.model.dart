import 'package:equatable/equatable.dart';

rekapKehadiranModelFromJson(List<dynamic> list) =>
    List<RekapKehadiranModel>.from(
        list.map((json) => RekapKehadiranModel.fromJson(json)));

class RekapKehadiranModel extends Equatable {
  final String SUBTY;
  final String ATEXT;
  final String JUMLAH_HARI;

  const RekapKehadiranModel({
    required this.SUBTY,
    required this.ATEXT,
    required this.JUMLAH_HARI,
  });

  static RekapKehadiranModel fromJson(Map<String, dynamic> json) =>
      RekapKehadiranModel(
        SUBTY: json['SUBTY'],
        ATEXT: json['ATEXT'],
        JUMLAH_HARI: json['JUMLAH_HARI'],
      );

  @override
  List<Object> get props => [
        SUBTY,
        ATEXT,
        JUMLAH_HARI,
      ];
}
