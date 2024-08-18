import 'package:easy/core/common/entities/user.dart';
import 'package:easy/features/auth/domain/repository/auth_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class ReAuthenticate implements UseCase<User, NoParams> {
  final AuthRepository repository;

  ReAuthenticate(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return repository.reAuthenticate();
  }
}
