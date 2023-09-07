part of 'kehadiran_bloc.dart';

abstract class KehadiranEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NikChanged extends KehadiranEvent {
  final String nik;

  NikChanged({required this.nik});

  @override
  List<Object?> get props => [nik];
}

class TglMulaiChanged extends KehadiranEvent {
  final DateTime tglMulai;

  TglMulaiChanged({required this.tglMulai});

  @override
  List<Object?> get props => [tglMulai];
}

class TglAkhirChanged extends KehadiranEvent {
  final DateTime tglAkhir;

  TglAkhirChanged({required this.tglAkhir});

  @override
  List<Object?> get props => [tglAkhir];
}

class JenisChanged extends KehadiranEvent {
  final LaporanType type;

  JenisChanged({required this.type});

  @override
  List<Object?> get props => [type];
}

class ThnBlnChanged extends KehadiranEvent {
  final DateTime thnBln;

  ThnBlnChanged({required this.thnBln});

  @override
  List<Object?> get props => [thnBln];
}

class RekapKehadiranChanged extends KehadiranEvent {
  final List<RekapKehadiranModel> rekapKehadiran;

  RekapKehadiranChanged({required this.rekapKehadiran});

  @override
  List<Object?> get props => [rekapKehadiran];
}

class KehadiranHarianChanged extends KehadiranEvent {
  final List<RekapKehadiranHarianModel> kehadiranHarian;

  KehadiranHarianChanged({required this.kehadiranHarian});

  @override
  List<Object?> get props => [kehadiranHarian];
}

class Loading extends KehadiranEvent {
  Loading();
}

class Iddle extends KehadiranEvent {
  Iddle();
}
