import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PayslipRepository {
  Future<Either<Failure, String>> getPayslip({
    required String nik,
    required DateTimeRange range,
  });
}
