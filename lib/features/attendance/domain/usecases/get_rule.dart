import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetRule implements UseCase<Rule, GetRuleParams> {
  final AttendanceRepository repository;

  GetRule(this.repository);

  @override
  Future<Either<Failure, Rule>> call(GetRuleParams params) {
    return repository.getRule(
      codeCabang: params.codeCabang,
      nik: params.nik,
    );
  }
}

class GetRuleParams {
  final String codeCabang;
  final String nik;

  GetRuleParams({required this.codeCabang, required this.nik});
}
