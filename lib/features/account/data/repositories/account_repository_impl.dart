import 'package:easy/core/constants/constants.dart';
import 'package:easy/features/account/data/remote_datasources/account_remote_datasource.dart';
import 'package:easy/features/account/domain/entities/account.dart';
import 'package:easy/features/account/domain/repositories/account_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDatasource accountRemoteDatasource;
  final ConnectionChecker connectionChecker;

  AccountRepositoryImpl(
    this.accountRemoteDatasource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Account>> getCurrentAccount(String nik) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final account = await accountRemoteDatasource.getCurrentUser(nik);

      return left(Failure("e.message"));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
