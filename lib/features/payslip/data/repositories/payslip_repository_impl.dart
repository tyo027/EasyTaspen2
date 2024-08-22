import 'package:easy/core/constants/constants.dart';
import 'package:easy/features/payslip/data/remote_datasources/payslip_remote_datasource.dart';
import 'package:easy/features/payslip/domain/repositories/payslip_repository.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

class PayslipRepositoryImpl implements PayslipRepository {
  final ConnectionChecker connectionChecker;
  final PayslipRemoteDatasource payslipRemoteDatasource;

  PayslipRepositoryImpl(
    this.payslipRemoteDatasource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, String>> getPayslip({
    required String nik,
    required DateTimeRange range,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final payslip = await payslipRemoteDatasource.getPayslip(
        nik: nik,
        bulanTahun: DateFormat("yyyyMM").format(
          range.start,
        ),
      );

      return right(payslip);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
