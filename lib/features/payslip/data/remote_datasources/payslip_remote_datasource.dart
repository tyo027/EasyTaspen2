import 'dart:convert';

import 'package:easy/core/constants/api.dart';
import 'package:fca/fca.dart';

abstract interface class PayslipRemoteDatasource {
  Future<String> getPayslip({
    required String nik,
    required String bulanTahun,
  });
}

class PayslipRemoteDatasourceImpl implements PayslipRemoteDatasource {
  final InterceptedClient client;

  PayslipRemoteDatasourceImpl(this.client);

  @override
  Future<String> getPayslip({
    required String nik,
    required String bulanTahun,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(Api.payslip),
        body: jsonEncode({
          "nik": nik,
          "blnthn": bulanTahun,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return response.body;
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
