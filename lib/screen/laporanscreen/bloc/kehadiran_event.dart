part of 'kehadiran_bloc.dart';

class KehadiranEvent extends Equatable {
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
  final String tglMulai;

  TglMulaiChanged({required this.tglMulai});

  @override
  List<Object?> get props => [tglMulai];
}

class TglAkhirChanged extends KehadiranEvent {
  final String tglAkhir;

  TglAkhirChanged({required this.tglAkhir});

  @override
  List<Object?> get props => [tglAkhir];
}
