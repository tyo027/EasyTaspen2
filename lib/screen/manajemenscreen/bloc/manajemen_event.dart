part of 'manajemen_bloc.dart';

abstract class ManajemenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadManajemenUserData extends ManajemenEvent {
  final String nik;

  LoadManajemenUserData({required this.nik});
}

class UpdateState extends ManajemenEvent {
  final List<CekStaffModel>? staff;
  final CekStaffModel? selectedStaff;
  final LaporanType? selectedType;
  final DateTime? thnBln;
  final DateTime? tglMulai;
  final DateTime? tglAkhir;

  UpdateState({
    this.staff,
    this.selectedStaff,
    this.selectedType,
    this.thnBln,
    this.tglMulai,
    this.tglAkhir,
  });
}

class Search extends ManajemenEvent {}
