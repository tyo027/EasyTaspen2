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

class RegisterGenderChanged extends RegisterEvent {
  final String gender;

  const RegisterGenderChanged({required this.gender});

  @override
  List<Object> get props => [gender];
}

class RegisterPhoneChanged extends RegisterEvent {
  final String phone;

  const RegisterPhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];
}

class RegisterJobChanged extends RegisterEvent {
  final String job;

  const RegisterJobChanged({required this.job});

  @override
  List<Object> get props => [job];
}
