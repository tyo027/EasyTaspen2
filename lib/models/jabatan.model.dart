import 'package:equatable/equatable.dart';

jabatanModelFromJson(List<dynamic> list) =>
    List<JabatanModel>.from(list.map((json) => JabatanModel.fromJson(json)));

class JabatanModel extends Equatable {
  final String tglMulai;
  final String tglAkhir;
  final String namaJabatan;
  final String unitKerja;
  final String tahunKerja;
  final String bulanKerja;
  final String hariKerja;

  const JabatanModel({
    required this.tglMulai,
    required this.tglAkhir,
    required this.namaJabatan,
    required this.unitKerja,
    required this.tahunKerja,
    required this.bulanKerja,
    required this.hariKerja,
  });

  static JabatanModel fromJson(Map<String, dynamic> json) => JabatanModel(
        tglMulai: json['TGL_MULAI'],
        tglAkhir: json['TGL_AKHIR'],
        namaJabatan: json['NAMA_JABATAN'],
        unitKerja: json['UNIT_KERJA'],
        tahunKerja: json['TAHUN_KERJA'],
        bulanKerja: json['BULAN_KERJA'],
        hariKerja: json['HARI_KERJA'],
      );

  @override
  List<Object> get props => [
        tglMulai,
        tglAkhir,
        namaJabatan,
        unitKerja,
        tahunKerja,
        bulanKerja,
        hariKerja,
      ];
}
