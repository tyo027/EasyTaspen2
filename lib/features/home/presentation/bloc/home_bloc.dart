import 'dart:async';

import 'package:easy/features/home/domain/usecases/get_home_data.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

class HomeBloc extends BaseBloc<HomeEvent> {
  final GetHomeData getHomeData;
  HomeBloc(this.getHomeData) : super() {
    on<LoadHomeData>(_loadHomeData);
    on<ResetHome>(
      (event, emit) => emit(InitialState()),
    );
  }

  FutureOr<void> _loadHomeData(
    LoadHomeData event,
    Emitter<BaseState> emit,
  ) async {
    emit(LoadingState());
    final result = await getHomeData(GetHomeDataParams(nik: event.nik));

    result.fold((failure) {
      emit(FailureState(failure.message));
    }, (home) {
      emit(SuccessState(home));
    });
  }
}
