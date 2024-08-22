import 'package:easy/features/payslip/domain/repositories/payslip_repository.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class GetPayslip implements UseCase<String, GetPayslipParams> {
  final PayslipRepository repository;

  GetPayslip(this.repository);

  @override
  Future<Either<Failure, String>> call(GetPayslipParams params) {
    return repository.getPayslip(
      nik: params.nik,
      range: params.range,
    );
  }
}

class GetPayslipParams {
  final String nik;
  final DateTimeRange range;

  GetPayslipParams({required this.nik, required this.range});
}
