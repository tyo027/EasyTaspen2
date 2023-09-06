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
  final String jenis;

  JenisChanged({required this.jenis});

  @override
  List<Object?> get props => [jenis];
}

class ThnBlnChanged extends KehadiranEvent {
  final DateTime thnBln;

  ThnBlnChanged({required this.thnBln});

  @override
  List<Object?> get props => [thnBln];
}
