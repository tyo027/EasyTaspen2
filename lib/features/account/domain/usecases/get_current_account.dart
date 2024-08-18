import 'package:easy/features/account/domain/entities/account.dart';
import 'package:easy/features/account/domain/repositories/account_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentAccount implements UseCase<Account, String> {
  final AccountRepository repository;

  GetCurrentAccount(this.repository);

  @override
  Future<Either<Failure, Account>> call(String nik) {
    return repository.getCurrentAccount(nik);
  }
}
