import 'package:easy/models/attendance.model.dart';
import 'package:easy/models/cekstaff.model.dart';
import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/models/rekapkehadiranharian.model.dart';
import 'package:easy/repositories/attendance.repository.dart';
import 'package:easy/repositories/cekstaff.repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manajemen_event.dart';
part 'manajemen_state.dart';

class ManajemenBloc extends Bloc<ManajemenEvent, ManajemenState> {
  ManajemenBloc() : super(InitialState()) {
    on<LoadManajemenUserData>(
      (event, emit) async {
        emit(SuccessState(isLoading: true));

        final staff = await CekStaff().getStaff(nik: event.nik);

        emit(
          SuccessState(
            isLoading: false,
            staff: staff,
            selectedStaff: null,
            selectedType: LaporanType.CEK_ABSEN_HARIAN,
          ),
        );
      },
    );

    on<UpdateState>(
      (event, emit) {
        final currentState = state;

        if (currentState is SuccessState) {
          emit(currentState.copyWith(isLoading: true));

          emit(currentState.copyWith(
            selectedStaff: event.selectedStaff,
            selectedType: event.selectedType,
            staff: event.staff,
            tglAkhir: event.tglAkhir,
            tglMulai: event.tglMulai,
            thnBln: event.thnBln,
          ));
        }
      },
    );

    on<Search>((event, emit) async {
      final currentState = state;

      if (currentState is SuccessState) {
        emit(currentState.copyWith(
          isLoading: true,
          thnBln: currentState.thnBln,
          tglAkhir: currentState.tglAkhir,
          tglMulai: currentState.tglMulai,
        ));

        if (currentState.selectedType == LaporanType.CEK_ABSEN_HARIAN) {
          final attendances = await AttendanceRepository()
              .getAttendances(nik: currentState.selectedStaff!.nik);

          emit(
            currentState.copyWith(
              attendances: attendances,
              isLoading: false,
            ),
          );
        }

        if (currentState.selectedType == LaporanType.REKAP_KEHADIRAN) {
          var startTime = currentState.thnBln!.copyWith(day: 1);
          var endTime = startTime.copyWith(month: startTime.month + 1, day: 0);

          final rekapKehadiran = await AttendanceRepository().getRekapKehadiran(
              nik: currentState.selectedStaff!.nik,
              tglMulai: startTime.toString().substring(0, 10),
              tglAkhir: endTime.toString().substring(0, 10));

          emit(
            currentState.copyWith(
              isLoading: false,
              rekapKehadiran: rekapKehadiran,
              thnBln: currentState.thnBln,
            ),
          );
        }

        if (currentState.selectedType ==
            LaporanType.KEHADIRAN_HARIAN_VERIFIED) {
          final listKehadiranHarian = await AttendanceRepository()
              .getRekapKehadiranHarian(
                  nik: currentState.selectedStaff!.nik,
                  tglMulai: currentState.tglMulai.toString().substring(0, 10),
                  tglAkhir: currentState.tglAkhir.toString().substring(0, 10));

          emit(
            currentState.copyWith(
              isLoading: false,
              listKehadiranHarian: listKehadiranHarian,
              tglMulai: currentState.tglMulai,
              tglAkhir: currentState.tglAkhir,
            ),
          );
        }
      }
    });
  }
}
