import 'package:bloc/bloc.dart';
import 'package:easy/repositories/admin.repository.dart';
import 'package:easy/screen/authentication/bloc/login_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminView view;
  final BuildContext context;

  AdminBloc(this.view, this.context) : super(const AdminState(username: "")) {
    on<AdminChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });
    on<DeleteUnChanged>((event, emit) async {
      if (!state.isFilled && !context.mounted) return;
      view.showLoading(context);
      try {
        await AdminRepository().adminRepository(
          username: state.username,
        );
        view.hideLoading();
        view.showToast(context, "Akun Berhasil Di-reset");
      } catch (e) {
        print(e);
        view.hideLoading();
        view.showToast(context, "Periksa Kembali Username Yang Dimaksud");
      }
    });
  }
}

abstract class AdminView {
  void showLoading(BuildContext context);
  void hideLoading();
  void showToast(BuildContext context, String message);
}
