part of 'kehadiran_bloc.dart';

class KehadiranState extends Equatable {
  final bool isLoading;

  const KehadiranState({
    required this.isLoading,
  });

  bool get isEnabled => false;

  @override
  List<Object?> get props => [isLoading];
}

class RekapKehadiran extends KehadiranState {
  final DateTime? thnBln;
  final List<RekapKehadiranModel>? rekapKehadiran;

  const RekapKehadiran(
      {this.thnBln, this.rekapKehadiran, bool isLoading = false})
      : super(isLoading: isLoading);

  @override
  bool get isEnabled => thnBln != null;

  @override
  List<Object?> get props => [thnBln, rekapKehadiran, isLoading];
}

class KehadiranHarianVerified extends KehadiranState {
  final DateTime? tglMulai;
  final DateTime? tglAkhir;
  final List<RekapKehadiranHarianModel>? kehadiranHarian;

  const KehadiranHarianVerified(
      {this.tglMulai,
      this.tglAkhir,
      this.kehadiranHarian,
      bool isLoading = false})
      : super(isLoading: isLoading);

  @override
  bool get isEnabled => tglMulai != null && tglAkhir != null;

  @override
  List<Object?> get props => [tglMulai, tglAkhir, kehadiranHarian, isLoading];
}

class CekAbsenHarian extends KehadiranState {
  final List<AttendanceModel>? attandances;

  const CekAbsenHarian({bool isLoading = false, this.attandances})
      : super(isLoading: isLoading);

  @override
  bool get isEnabled => true;

  @override
  List<Object?> get props => [isLoading, attandances];
}

// class KehadiranState extends Equatable {
//   final String nik;
//   final LaporanType type;
//   final DateTime? thnBln;
//   final DateTime? tglMulai;
//   final DateTime? tglAkhir;
//   final List<RekapKehadiranModel>? rekapKehadiran;
//   final List<RekapKehadiranHarianModel>? kehadiranHarian;
//   final bool isProcessing;

//   const KehadiranState(
//       {this.type = LaporanType.REKAP_KEHADIRAN,
//       this.nik = '',
//       this.thnBln,
//       this.tglMulai,
//       this.tglAkhir,
//       this.rekapKehadiran,
//       this.kehadiranHarian,
//       this.isProcessing = false});

//   KehadiranState copyWith(
//           {LaporanType? type,
//           String? nik,
//           DateTime? thnBln,
//           DateTime? tglMulai,
//           DateTime? tglAkhir,
//           List<RekapKehadiranModel>? rekapKehadiran,
//           List<RekapKehadiranHarianModel>? kehadiranHarian,
//           bool? isProcessing}) =>
//       KehadiranState(
//         type: type ?? this.type,
//         thnBln: thnBln ?? this.thnBln,
//         nik: nik ?? this.nik,
//         tglMulai: tglMulai ?? this.tglMulai,
//         tglAkhir: tglAkhir ?? this.tglAkhir,
//         rekapKehadiran: rekapKehadiran ?? this.rekapKehadiran,
//         kehadiranHarian: kehadiranHarian ?? this.kehadiranHarian,
//         isProcessing: isProcessing ?? this.isProcessing,
//       );

//   @override
//   List<Object?> get props => [
//         nik,
//         tglMulai,
//         tglAkhir,
//         type,
//         thnBln,
//         rekapKehadiran,
//         isProcessing,
//         kehadiranHarian
//       ];
// }
