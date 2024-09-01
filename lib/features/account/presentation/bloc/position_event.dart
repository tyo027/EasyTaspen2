part of 'position_bloc.dart';

@immutable
sealed class PositionEvent {}

final class GetPosition extends PositionEvent {
  final String nik;

  GetPosition({required this.nik});
}

final class ResetPosition extends PositionEvent {}
