import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AttendanceRepository {
  Future<Either<Failure, Rule>> getRule({
    required String codeCabang,
    required String nik,
  });
}
