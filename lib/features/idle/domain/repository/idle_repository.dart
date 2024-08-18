import 'package:easy/features/idle/domain/entity/idle_status.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IdleRepository {
  Future<Either<Failure, IdleStatus>> getIdleStatus();

  Future<Either<Failure, IdleStatus>> activateIdle();
}
