import 'package:easy/features/idle/domain/entity/idle_status.dart';
import 'package:easy/features/idle/domain/repository/idle_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class ActivateIdle implements UseCase<IdleStatus, NoParams> {
  final IdleRepository idleRepository;

  ActivateIdle(this.idleRepository);

  @override
  Future<Either<Failure, IdleStatus>> call(NoParams params) {
    return idleRepository.activateIdle();
  }
}
