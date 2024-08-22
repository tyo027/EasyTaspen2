import 'dart:async';

import 'package:easy/features/payslip/domain/usecases/get_payslip.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payslip_event.dart';

class PayslipBloc extends BaseBloc<PayslipEvent> {
  final GetPayslip getPayslip;

  PayslipBloc(this.getPayslip) : super() {
    on<LoadPayslip>(_loadPayslip);
  }

  FutureOr<void> _loadPayslip(
    LoadPayslip event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final result = await getPayslip(GetPayslipParams(
      nik: event.nik,
      range: event.range,
    ));

    result.fold(
      (failure) => emit(FailureState(failure.message)),
      (home) => emit(SuccessState(home)),
    );
  }
}
