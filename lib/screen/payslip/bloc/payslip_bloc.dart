import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payslip_event.dart';
part 'payslip_state.dart';

class PayslipBloc extends Bloc<PayslipEvent, PayslipState> {
  PayslipBloc() : super(const PayslipState(thnbln: "", payslip: "")) {
    on<ThnBlnChanged>((event, emit) {
      emit(state.copyWith(thnbln: event.thnbln));
    });

    on<PaySlipChanged>((event, emit) {
      emit(state.copyWith(payslip: event.payslip));
    });
  }
}
