import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'kehadiran_event.dart';
part 'kehadiran_state.dart';

class KehadiranBloc extends Bloc<KehadiranEvent, KehadiranState> {
  KehadiranBloc() : super(KehadiranState(nik: "", tglMulai: "", tglAkhir: "")) {
    on<NikChanged>((event, emit) {
      emit(state.copyWith(nik: event.nik));
    });

    on<TglMulaiChanged>((event, emit) {
      emit(state.copyWith(tglMulai: event.tglMulai));
    });

    on<TglAkhirChanged>((event, emit) {
      emit(state.copyWith(tglAkhir: event.tglAkhir));
    });
  }
}
