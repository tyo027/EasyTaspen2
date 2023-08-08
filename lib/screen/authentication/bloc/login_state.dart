part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String userName;
  final String password;
  final bool isPasswordShow;

  const LoginState({
    this.userName = "",
    this.password = "",
    this.isPasswordShow = false,
  });

  LoginState copyWith({
    String? userName,
    String? password,
    bool? isPasswordShow,
  }) =>
      LoginState(
        userName: userName ?? this.userName,
        password: password ?? this.password,
        isPasswordShow: isPasswordShow ?? this.isPasswordShow,
      );

  @override
  List<Object?> get props => [userName, password, isPasswordShow];
}
