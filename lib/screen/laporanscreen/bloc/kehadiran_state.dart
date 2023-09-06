part of 'kehadiran_bloc.dart';

class KehadiranState extends Equatable {
  final String nik;
  final String jenis;
  final DateTime? thnBln;
  final DateTime? tglMulai;
  final DateTime? tglAkhir;

  const KehadiranState({
    this.jenis = 'REKAP_BULANAN',
    this.nik = '',
    this.thnBln,
    this.tglMulai,
    this.tglAkhir,
  });

  KehadiranState copyWith({
    String? jenis,
    String? nik,
    DateTime? thnBln,
    DateTime? tglMulai,
    DateTime? tglAkhir,
  }) =>
      KehadiranState(
        jenis: jenis ?? this.jenis,
        thnBln: thnBln ?? this.thnBln,
        nik: nik ?? this.nik,
        tglMulai: tglMulai ?? this.tglMulai,
        tglAkhir: tglAkhir ?? this.tglAkhir,
      );

  @override
  List<Object?> get props => [nik, tglMulai, tglAkhir, jenis, thnBln];
}
