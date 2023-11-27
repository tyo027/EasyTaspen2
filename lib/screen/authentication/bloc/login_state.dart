part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final bool isPasswordShow;

  const LoginState({
    this.username = "",
    this.password = "",
    this.isPasswordShow = false,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isPasswordShow,
  }) =>
      LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        isPasswordShow: isPasswordShow ?? this.isPasswordShow,
      );

  @override
  List<Object?> get props => [username, password, isPasswordShow];

  get isFilled => (username != "" && password != "");
}
