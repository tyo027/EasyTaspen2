import 'package:easy/core/common/entities/user.dart';
import 'package:easy/features/auth/domain/repository/auth_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  CurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return repository.currentUser();
  }
}