part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationCheckRequested extends AuthenticationEvent {
  final bool isBiometric;

  AuthenticationCheckRequested({this.isBiometric = false});

  @override
  List<Object?> get props => [isBiometric];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final UserModel user;

  AuthenticationLoginRequested({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationExpiredRequested extends AuthenticationEvent {}
