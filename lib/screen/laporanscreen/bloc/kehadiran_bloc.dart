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
      emit(state.copyWith(jenis: event.jenis));
    });
  }
}
