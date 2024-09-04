import 'dart:async';

import 'package:easy/features/attendance/domain/usecases/get_rule.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rule_event.dart';

class RuleBloc extends BaseBloc<RuleEvent> {
  GetRule getRule;

  RuleBloc(this.getRule) : super() {
    on<GetRuleData>(_getRuleData);
    on<ResetRule>((event, emit) => emit(InitialState())) ;
  }

  FutureOr<void> _getRuleData(
    GetRuleData event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await getRule(
      GetRuleParams(
        codeCabang: event.codeCabang,
        nik: event.nik,
      ),
    );

    response.fold(
      (failure) {
        emit(FailureState(failure.message));
      },
      (rule) {
        emit(SuccessState(rule));
      },
    );
  }
}
