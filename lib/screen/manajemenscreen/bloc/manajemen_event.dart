part of 'manajemen_bloc.dart';

abstract class ManajemenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadManajemenUserData extends ManajemenEvent {
  final String nik;

  LoadManajemenUserData({required this.nik});
}
