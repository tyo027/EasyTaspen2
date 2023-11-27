part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({required this.username});

  @override
  List<Object?> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class LoginPasswordShowChanged extends LoginEvent {
  final bool isPasswordShow;

  LoginPasswordShowChanged({required this.isPasswordShow});

  @override
  List<Object?> get props => [isPasswordShow];
}

class LoginRequestedEvent extends LoginEvent {}

class LoginRequestedBiometricEvent extends LoginEvent {}
