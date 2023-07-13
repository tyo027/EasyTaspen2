part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterFullnameChanged extends RegisterEvent {
  final String fullname;

  const RegisterFullnameChanged({required this.fullname});

  @override
  List<Object> get props => [fullname];
}

class RegisterUserNameChanged extends RegisterEvent {
  final String userName;

  const RegisterUserNameChanged({required this.userName});

  @override
  List<Object> get props => [userName];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}
