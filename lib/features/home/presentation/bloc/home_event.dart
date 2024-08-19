part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LoadHomeData extends HomeEvent {
  final String nik;

  LoadHomeData({required this.nik});
}
