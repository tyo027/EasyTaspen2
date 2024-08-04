part of 'manajemen_bloc.dart';

class ManajemenState extends Equatable {
  final bool isLoading;
  final List<CekStaffModel> staff;

  const ManajemenState({
    required this.isLoading,
    required this.staff,
  });

  @override
  List<Object?> get props => [isLoading, staff];
}
