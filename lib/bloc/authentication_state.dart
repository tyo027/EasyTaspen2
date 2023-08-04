part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated, expired }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;
  final String? message;

  const AuthenticationState._(
      {this.status = AuthenticationStatus.unknown, this.user, this.message});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated({UserModel? user})
      : this._(user: user, status: AuthenticationStatus.authenticated);

  const AuthenticationState.expired()
      : this._(status: AuthenticationStatus.expired);

  const AuthenticationState.unauthenticated({String? message})
      : this._(status: AuthenticationStatus.unauthenticated, message: message);

  @override
  List<Object?> get props => [status, user, message];
}
