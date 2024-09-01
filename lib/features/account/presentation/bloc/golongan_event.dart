part of 'golongan_bloc.dart';

@immutable
sealed class GolonganEvent {}

final class GetGolongan extends GolonganEvent {
  final String nik;

  GetGolongan({required this.nik});
}

final class ResetGolongan extends GolonganEvent {}
