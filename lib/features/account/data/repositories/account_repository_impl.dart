import 'package:easy/core/constants/constants.dart';
import 'package:easy/features/account/data/remote_datasources/account_remote_datasource.dart';
import 'package:easy/features/account/domain/entities/account.dart';
import 'package:easy/features/account/domain/entities/golongan.dart';
import 'package:easy/features/account/domain/entities/position.dart';
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

      return right(account);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Position>>> getCurrentPosition(String nik) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final position = await accountRemoteDatasource.getCurrentPosition(nik);

      return right(position);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Golongan>>> getCurrentGolongan(String nik) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final golongan = await accountRemoteDatasource.getCurrentGolongan(nik);

      return right(golongan);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
