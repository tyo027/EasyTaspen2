import 'package:easy/core/common/entities/user.dart';
import 'package:easy/features/auth/domain/repository/auth_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class SignIn implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return repository.signIn(
      username: params.username,
      password: params.password,
    );
  }
}

class SignInParams {
  final String username;
  final String password;

  SignInParams({
    required this.username,
    required this.password,
  });
}
