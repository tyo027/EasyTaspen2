part of 'kehadiran_bloc.dart';

class KehadiranState extends Equatable {
  final String nik;
  final LaporanType type;
  final DateTime? thnBln;
  final DateTime? tglMulai;
  final DateTime? tglAkhir;
  final List<RekapKehadiranModel>? rekapKehadiran;
  final List<RekapKehadiranHarianModel>? kehadiranHarian;
  final bool isProcessing;

  const KehadiranState(
      {this.type = LaporanType.REKAP_KEHADIRAN,
      this.nik = '',
      this.thnBln,
      this.tglMulai,
      this.tglAkhir,
      this.rekapKehadiran,
      this.kehadiranHarian,
      this.isProcessing = false});

  KehadiranState copyWith(
          {LaporanType? type,
          String? nik,
          DateTime? thnBln,
          DateTime? tglMulai,
          DateTime? tglAkhir,
          List<RekapKehadiranModel>? rekapKehadiran,
          List<RekapKehadiranHarianModel>? kehadiranHarian,
          bool? isProcessing}) =>
      KehadiranState(
        type: type ?? this.type,
        thnBln: thnBln ?? this.thnBln,
        nik: nik ?? this.nik,
        tglMulai: tglMulai ?? this.tglMulai,
        tglAkhir: tglAkhir ?? this.tglAkhir,
        rekapKehadiran: rekapKehadiran ?? this.rekapKehadiran,
        kehadiranHarian: kehadiranHarian ?? this.kehadiranHarian,
        isProcessing: isProcessing ?? this.isProcessing,
      );

  @override
  List<Object?> get props => [
        nik,
        tglMulai,
        tglAkhir,
        type,
        thnBln,
        rekapKehadiran,
        isProcessing,
        kehadiranHarian
      ];
}
