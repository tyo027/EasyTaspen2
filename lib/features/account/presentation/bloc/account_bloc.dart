import 'dart:async';

import 'package:easy/features/account/domain/usecases/get_current_account.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_event.dart';

class AccountBloc extends BaseBloc<AccountEvent> {
  final GetCurrentAccount getCurrentAccount;

  AccountBloc(this.getCurrentAccount) : super() {
    on<GetAccount>(_getAccount);
  }

  FutureOr<void> _getAccount(
    GetAccount event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());

    final response = await getCurrentAccount(event.nik);

    response.fold(
      (failure) {
        emit(FailureState(failure.message));
      },
      (account) {
        emit(SuccessState(account));
      },
    );
  }
}
