part of 'rule_bloc.dart';

@immutable
sealed class RuleEvent {}

final class GetRuleData extends RuleEvent {
  final String codeCabang;
  final String nik;

  GetRuleData({
    required this.codeCabang,
    required this.nik,
  });
}

final class ResetRule extends RuleEvent {}
