import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/models/rekapkehadiranharian.model.dart';
import 'package:easy/screen/laporanscreen/laporans.screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'kehadiran_event.dart';
part 'kehadiran_state.dart';

class KehadiranBloc extends Bloc<KehadiranEvent, KehadiranState> {
  KehadiranBloc() : super(const KehadiranState()) {
    on<NikChanged>((event, emit) {
      emit(state.copyWith(nik: event.nik));
    });

    on<TglMulaiChanged>((event, emit) {
      emit(state.copyWith(tglMulai: event.tglMulai));
    });

    on<TglAkhirChanged>((event, emit) {
      emit(state.copyWith(tglAkhir: event.tglAkhir));
    });

    on<ThnBlnChanged>((event, emit) {
      emit(state.copyWith(thnBln: event.thnBln));
    });

    on<JenisChanged>((event, emit) {
      emit(state.copyWith(type: event.type));
    });

    on<RekapKehadiranChanged>((event, emit) {
      emit(state.copyWith(rekapKehadiran: event.rekapKehadiran));
    });

    on<KehadiranHarianChanged>((event, emit) {
      emit(state.copyWith(kehadiranHarian: event.kehadiranHarian));
    });

    on<Loading>((event, emit) {
      emit(state.copyWith(isProcessing: true));
    });

    on<Iddle>((event, emit) {
      emit(state.copyWith(isProcessing: false));
    });
  }
}
