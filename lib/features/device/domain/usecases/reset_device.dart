import 'package:easy/features/device/domain/repositories/device_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class ResetDevice implements UseCase<bool, String> {
  final DeviceRepository repository;

  ResetDevice(this.repository);

  @override
  Future<Either<Failure, bool>> call(String username) {
    return repository.resetDevice(username: username);
  }
}
