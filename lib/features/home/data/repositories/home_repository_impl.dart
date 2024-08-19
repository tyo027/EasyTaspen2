import 'package:easy/core/constants/constants.dart';
import 'package:easy/features/account/data/remote_datasources/account_remote_datasource.dart';
import 'package:easy/features/home/domain/entities/home.dart';
import 'package:easy/features/home/domain/repositories/home_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ConnectionChecker connectionChecker;
  final AccountRemoteDatasource accountRemoteDatasource;

  HomeRepositoryImpl(
    this.accountRemoteDatasource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Home>> getHomeData({
    required String nik,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final isAdmin = await accountRemoteDatasource.isAdmin(nik);

      final employee = await accountRemoteDatasource.getCurrentEmployee(nik);

      return right(
        Home(isAdmin: isAdmin, employee: employee),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
