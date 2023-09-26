part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NeedPermissions extends AuthenticationState {}

class NeedUpdate extends AuthenticationState {
  final AppCheckerResult version;

  NeedUpdate({required this.version});
}

class Unknown extends AuthenticationState {}

class UnAuthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final UserModel user;

  Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Expired extends AuthenticationState {}
