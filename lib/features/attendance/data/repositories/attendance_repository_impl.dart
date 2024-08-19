import 'package:easy/core/constants/constants.dart';
import 'package:easy/features/attendance/data/remote_datasources/attendance_remote_datasource.dart';
import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDatasource attendanceRemoteDatasource;
  final ConnectionChecker connectionChecker;

  AttendanceRepositoryImpl(
    this.attendanceRemoteDatasource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Rule>> getRule({
    required String codeCabang,
    required String nik,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final rule = await attendanceRemoteDatasource.getRule(codeCabang);

      final mpp = await attendanceRemoteDatasource.getMpp(nik);

      if (mpp.isCustom) {
        return right(rule.copyWith(
          lat: mpp.lat,
          long: mpp.long,
          jarak: mpp.radius,
        ));
      }

      return right(rule);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
