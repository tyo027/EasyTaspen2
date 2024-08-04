import 'package:equatable/equatable.dart';

cekStaffModelFromJson(List<dynamic> list) =>
    List<CekStaffModel>.from(list.map((json) => CekStaffModel.fromJson(json)));

class CekStaffModel extends Equatable {
  final String nik;
  final String nama;
  final String positionname;

  const CekStaffModel({
    required this.nik,
    required this.nama,
    required this.positionname,
  });

  static CekStaffModel fromJson(Map<String, dynamic> json) => CekStaffModel(
        nik: json['NIK'].toString(),
        nama: json['NAMA'],
        positionname: json['POSITIONNAME'],
      );

  @override
  List<Object> get props => [
        nik,
        nama,
        positionname,
      ];
}
