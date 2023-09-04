part of 'kehadiran_bloc.dart';

class KehadiranState extends Equatable {
  final String nik;
  final String tglMulai;
  final String tglAkhir;

  const KehadiranState({
    required this.nik,
    required this.tglMulai,
    required this.tglAkhir,
  });

  KehadiranState copyWith({
    String? nik,
    String? tglMulai,
    String? tglAkhir,
  }) =>
      KehadiranState(
        nik: nik ?? this.nik,
        tglMulai: tglMulai ?? this.tglMulai,
        tglAkhir: tglAkhir ?? this.tglAkhir,
      );

  @override
  List<Object> get props => [
        nik,
        tglMulai,
        tglAkhir,
      ];
}
