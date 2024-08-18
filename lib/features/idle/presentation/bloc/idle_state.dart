part of 'idle_bloc.dart';

@immutable
sealed class IdleState {}

class IdleInitial extends IdleState {}

class IdleLoading extends IdleState {}

class IdleActive extends IdleState {}

class IdleExpired extends IdleState {}
