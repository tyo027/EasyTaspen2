part of 'idle_bloc.dart';

@immutable
sealed class IdleEvent {}

class CheckIdle extends IdleEvent {}

class UserActivityDetected extends IdleEvent {}
