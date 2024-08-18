import 'package:easy/core/common/entities/user.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String username,
    required String password,
  });

  Future<Either<Failure, User>> reAuthenticate();

  Future<Either<Failure, User>> currentUser();
}
