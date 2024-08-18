import 'package:easy/features/account/domain/entities/golongan.dart';
import 'package:easy/features/account/domain/repositories/account_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentGolongan implements UseCase<List<Golongan>, String> {
  final AccountRepository repository;

  GetCurrentGolongan(this.repository);

  @override
  Future<Either<Failure, List<Golongan>>> call(String nik) {
    return repository.getCurrentGolongan(nik);
  }
}
