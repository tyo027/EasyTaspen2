part of 'kehadiran_bloc.dart';

abstract class KehadiranEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RekapKehadiranEvent extends KehadiranEvent {
  final DateTime? thnBln;
  final List<RekapKehadiranModel>? rekapKehadiran;
  final bool isLoading;

  RekapKehadiranEvent(
      {this.thnBln, this.rekapKehadiran, this.isLoading = false});

  @override
  List<Object?> get props => [thnBln, rekapKehadiran, isLoading];
}

class KehadiranHarianVerifiedEvent extends KehadiranEvent {
  final DateTime? tglMulai;
  final DateTime? tglAkhir;
  final List<RekapKehadiranHarianModel>? kehadiranHarian;
  final bool isLoading;

  KehadiranHarianVerifiedEvent(
      {this.tglMulai,
      this.tglAkhir,
      this.kehadiranHarian,
      this.isLoading = false});

  @override
  List<Object?> get props => [tglMulai, tglAkhir, kehadiranHarian, isLoading];
}

class CekAbsenHarianEvent extends KehadiranEvent {
  final List<AttendanceModel>? attandances;
  final bool isLoading;

  CekAbsenHarianEvent({this.isLoading = false, this.attandances});

  @override
  List<Object?> get props => [isLoading, attandances];
}


// class NikChanged extends KehadiranEvent {
//   final String nik;

//   NikChanged({required this.nik});

//   @override
//   List<Object?> get props => [nik];
// }

// class TglMulaiChanged extends KehadiranEvent {
//   final DateTime tglMulai;

//   TglMulaiChanged({required this.tglMulai});

//   @override
//   List<Object?> get props => [tglMulai];
// }

// class TglAkhirChanged extends KehadiranEvent {
//   final DateTime tglAkhir;

//   TglAkhirChanged({required this.tglAkhir});

//   @override
//   List<Object?> get props => [tglAkhir];
// }

// class JenisChanged extends KehadiranEvent {
//   final LaporanType type;

//   JenisChanged({required this.type});

//   @override
//   List<Object?> get props => [type];
// }

// class ThnBlnChanged extends KehadiranEvent {
//   final DateTime thnBln;

//   ThnBlnChanged({required this.thnBln});

//   @override
//   List<Object?> get props => [thnBln];
// }

// class RekapKehadiranChanged extends KehadiranEvent {
//   final List<RekapKehadiranModel> rekapKehadiran;

//   RekapKehadiranChanged({required this.rekapKehadiran});

//   @override
//   List<Object?> get props => [rekapKehadiran];
// }

// class KehadiranHarianChanged extends KehadiranEvent {
//   final List<RekapKehadiranHarianModel> kehadiranHarian;

//   KehadiranHarianChanged({required this.kehadiranHarian});

//   @override
//   List<Object?> get props => [kehadiranHarian];
// }

// class Loading extends KehadiranEvent {
//   Loading();
// }

// class Iddle extends KehadiranEvent {
//   Iddle();
// }
