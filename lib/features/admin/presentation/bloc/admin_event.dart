part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

final class ResetUserDevice extends AdminEvent {
  final String username;

  ResetUserDevice(this.username);
}
