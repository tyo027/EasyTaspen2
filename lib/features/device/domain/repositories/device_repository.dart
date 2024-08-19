import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DeviceRepository {
  Future<Either<Failure, bool>> registerDevice({
    required String username,
    required String nik,
  });
}
