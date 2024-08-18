import 'package:easy/features/account/domain/entities/account.dart';
import 'package:easy/features/account/domain/entities/golongan.dart';
import 'package:easy/features/account/domain/entities/position.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountRepository {
  Future<Either<Failure, Account>> getCurrentAccount(String nik);

  Future<Either<Failure, List<Position>>> getCurrentPosition(String nik);

  Future<Either<Failure, List<Golongan>>> getCurrentGolongan(String nik);
}
