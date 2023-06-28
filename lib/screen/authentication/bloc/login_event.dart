part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUserNameChanged extends LoginEvent {
  final String userName;

  LoginUserNameChanged({required this.userName});

  @override
  List<Object?> get props => [userName];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}
