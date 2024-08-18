part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class IsUserLogged extends AuthEvent {}

final class Authenticate extends AuthEvent {
  final String username;
  final String password;

  Authenticate({
    required this.username,
    required this.password,
  });
}
