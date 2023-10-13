import 'package:easy/models/attendance.model.dart';
import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/models/rekapkehadiranharian.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'kehadiran_event.dart';
part 'kehadiran_state.dart';

class KehadiranBloc extends Bloc<KehadiranEvent, KehadiranState> {
  KehadiranBloc(KehadiranState state) : super(state) {
    on<RekapKehadiranEvent>((event, emit) {
      emit(RekapKehadiran(
          thnBln: event.thnBln,
          rekapKehadiran: event.rekapKehadiran,
          isLoading: event.isLoading));
    });

    on<KehadiranHarianVerifiedEvent>((event, emit) => emit(
        KehadiranHarianVerified(
            tglMulai: event.tglMulai,
            tglAkhir: event.tglAkhir,
            isLoading: event.isLoading,
            kehadiranHarian: event.kehadiranHarian)));

    on<CekAbsenHarianEvent>((event, emit) => emit(CekAbsenHarian(
        isLoading: event.isLoading, attandances: event.attandances)));
  }
}
