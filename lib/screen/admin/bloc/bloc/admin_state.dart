part of 'admin_bloc.dart';

class AdminState extends Equatable {
  final String username;

  const AdminState({
    required this.username,
  });

  AdminState copyWith({
    String? username,
  }) =>
      AdminState(
        username: username ?? this.username,
      );

  @override
  List<Object> get props => [
        username,
      ];
  get isFilled => (username != "");
}
