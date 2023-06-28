part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String userName;
  final String password;

  const LoginState({
    this.userName = "",
    this.password = "",
  });

  LoginState copyWith({
    String? userName,
    String? password,
  }) =>
      LoginState(
        userName: userName ?? this.userName,
        password: password ?? this.password,
      );

  @override
  List<Object?> get props => [userName, password];
}
