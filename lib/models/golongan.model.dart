
import 'package:equatable/equatable.dart';

golonganModelFromJson(List<dynamic> list) =>
    List<GolonganModel>.from(list.map((json) => GolonganModel.fromJson(json)));

class GolonganModel extends Equatable {
  final String tglMulai;
  final String tglAkhir;
  final String golongan;
  final String tahun;
  final String bulan;
  final String hari;

  const GolonganModel({
    required this.tglMulai,
    required this.tglAkhir,
    required this.golongan,
    required this.tahun,
    required this.bulan,
    required this.hari,
  });

  static GolonganModel fromJson(Map<String, dynamic> json) => GolonganModel(
        tglMulai: json['TGL_MULAI'],
        tglAkhir: json['TGL_AKHIR'],
        golongan: json['GOLONGAN'],
        tahun: json['TAHUN'],
        bulan: json['BULAN'],
        hari: json['HARI'],
      );

  @override
  List<Object> get props => [
        tglMulai,
        tglAkhir,
        golongan,
        tahun,
        bulan,
        hari,
      ];
}
