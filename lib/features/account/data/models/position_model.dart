import 'package:easy/features/account/domain/entities/position.dart';

class PositionModel extends Position {
  PositionModel({
    required super.tglMulai,
    required super.tglAkhir,
    required super.namaJabatan,
    required super.unitKerja,
    required super.tahunKerja,
    required super.bulanKerja,
    required super.hariKerja,
  });

  static PositionModel fromJson(Map<String, dynamic> json) {
    return PositionModel(
      tglMulai: json['TGL_MULAI'],
      tglAkhir: json['TGL_AKHIR'],
      namaJabatan: json['NAMA_JABATAN'],
      unitKerja: json['UNIT_KERJA'],
      tahunKerja: json['TAHUN_KERJA'],
      bulanKerja: json['BULAN_KERJA'],
      hariKerja: json['HARI_KERJA'],
    );
  }

  static List<PositionModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e)).toList();
  }
}
