part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String fullname;
  final String userName;
  final String password;

  const RegisterState({
    this.fullname = "",
    this.userName = "",
    this.password = "",
  });

  RegisterState copyWith({
    String? fullname,
    String? userName,
    String? password,
  }) =>
      RegisterState(
        fullname: fullname ?? this.fullname,
        userName: userName ?? this.userName,
        password: password ?? this.password,
      );

  @override
  List<Object?> get props => [userName, password, fullname];
}
