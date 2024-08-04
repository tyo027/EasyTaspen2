part of 'manajemen_bloc.dart';

class ManajemenState extends Equatable {
  @override
  List<Object?> get props => [];
}

enum LaporanType {
  CEK_ABSEN_HARIAN,
  REKAP_KEHADIRAN,
  KEHADIRAN_HARIAN_VERIFIED,
}

class InitialState extends ManajemenState {}

class SuccessState extends ManajemenState {
  final bool? isLoading;
  final List<CekStaffModel>? staff;
  final CekStaffModel? selectedStaff;
  final LaporanType? selectedType;
  final DateTime? thnBln;

  final DateTime? tglMulai;
  final DateTime? tglAkhir;

  final List<AttendanceModel>? attendances;
  final List<RekapKehadiranModel>? rekapKehadiran;
  final List<RekapKehadiranHarianModel>? listKehadiranHarian;

  SuccessState({
    this.staff,
    this.isLoading,
    this.selectedStaff,
    this.selectedType,
    this.thnBln,
    this.tglMulai,
    this.tglAkhir,
    this.attendances,
    this.rekapKehadiran,
    this.listKehadiranHarian,
  });

  @override
  List<Object?> get props => [
        isLoading,
        staff,
        selectedStaff,
        selectedType,
        thnBln,
        tglMulai,
        tglAkhir,
        attendances,
        rekapKehadiran,
        listKehadiranHarian,
      ];

  SuccessState copyWith({
    bool? isLoading,
    List<CekStaffModel>? staff,
    CekStaffModel? selectedStaff,
    LaporanType? selectedType,
    DateTime? thnBln,
    DateTime? tglMulai,
    DateTime? tglAkhir,
    List<AttendanceModel>? attendances,
    List<RekapKehadiranModel>? rekapKehadiran,
    List<RekapKehadiranHarianModel>? listKehadiranHarian,
  }) =>
      SuccessState(
        isLoading: isLoading ?? this.isLoading,
        staff: staff ?? this.staff,
        selectedStaff: selectedStaff ?? this.selectedStaff,
        selectedType: selectedType ?? this.selectedType,
        thnBln: thnBln,
        tglMulai: tglMulai,
        tglAkhir: tglAkhir,
        attendances: attendances,
        rekapKehadiran: rekapKehadiran,
        listKehadiranHarian: listKehadiranHarian,
      );
}
