part of 'admin_bloc.dart';

class AdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminChanged extends AdminEvent {
  final String username;

  AdminChanged({required this.username});

  @override
  List<Object?> get props => [username];
}

class DeleteUnChanged extends AdminEvent {}
