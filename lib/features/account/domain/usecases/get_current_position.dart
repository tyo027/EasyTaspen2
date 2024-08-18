import 'package:easy/features/account/domain/entities/position.dart';
import 'package:easy/features/account/domain/repositories/account_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentPosition implements UseCase<List<Position>, String> {
  final AccountRepository repository;

  GetCurrentPosition(this.repository);

  @override
  Future<Either<Failure, List<Position>>> call(String nik) {
    return repository.getCurrentPosition(nik);
  }
}
