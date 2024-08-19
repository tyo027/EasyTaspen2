import 'package:easy/features/idle/data/datasources/idle_datasource.dart';
import 'package:easy/features/idle/domain/entity/idle_status.dart';
import 'package:easy/features/idle/domain/repository/idle_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class IdleRepositoryImpl implements IdleRepository {
  final IdleDataSource idleDataSource;

  IdleRepositoryImpl(this.idleDataSource);

  @override
  Future<Either<Failure, IdleStatus>> getIdleStatus() async {
    try {
      final isIdle = await idleDataSource.isIdle();

      final idleStatus = IdleStatus(isIdle: isIdle);

      return right(idleStatus);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, IdleStatus>> activateIdle() async {
    await idleDataSource.saveLastIdle(DateTime.now());

    final idleStatus = IdleStatus(isIdle: true);

    return right(idleStatus);
  }
}
