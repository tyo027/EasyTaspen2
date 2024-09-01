part of 'account_bloc.dart';

@immutable
sealed class AccountEvent {}

final class GetAccount extends AccountEvent {
  final String nik;

  GetAccount({required this.nik});
}

final class ResetAccount extends AccountEvent {}
