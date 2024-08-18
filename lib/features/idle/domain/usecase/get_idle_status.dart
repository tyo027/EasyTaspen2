import 'package:easy/features/idle/domain/entity/idle_status.dart';
import 'package:easy/features/idle/domain/repository/idle_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetIdleStatus implements UseCase<IdleStatus, NoParams> {
  final IdleRepository repository;

  GetIdleStatus(this.repository);

  @override
  Future<Either<Failure, IdleStatus>> call(NoParams params) async {
    return repository.getIdleStatus();
  }
}
