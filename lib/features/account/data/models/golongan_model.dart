import 'package:easy/features/account/domain/entities/golongan.dart';

class GolonganModel extends Golongan {
  GolonganModel({
    required super.tglMulai,
    required super.tglAkhir,
    required super.golongan,
    required super.tahun,
    required super.bulan,
    required super.hari,
  });

  static GolonganModel fromJson(Map<String, dynamic> json) {
    return GolonganModel(
      tglMulai: json['TGL_MULAI'] ?? '',
      tglAkhir: json['TGL_AKHIR'] ?? '',
      golongan: json['GOLONGAN'] ?? '',
      tahun: json['TAHUN'] ?? '',
      bulan: json['BULAN'] ?? '',
      hari: json['HARI'] ?? '',
    );
  }

  static List<GolonganModel> fromJsonList(List<dynamic> list) {
    List<GolonganModel> golongans = [];

    for (var map in list) {
      var golongan = fromJson(map);
      if (golongan.tglMulai.isNotEmpty) {
        golongans.add(golongan);
      }
    }

    return golongans;
  }
}
