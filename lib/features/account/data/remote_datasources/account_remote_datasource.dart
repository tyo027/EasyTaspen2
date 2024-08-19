import 'dart:convert';

import 'package:easy/core/common/models/employee_model.dart';
import 'package:easy/core/constants/api.dart';
import 'package:easy/features/account/data/models/account_model.dart';
import 'package:easy/features/account/data/models/golongan_model.dart';
import 'package:easy/features/account/data/models/position_model.dart';
import 'package:fca/fca.dart';

abstract interface class AccountRemoteDatasource {
  Future<AccountModel> getCurrentUser(String nik);

  Future<List<PositionModel>> getCurrentPosition(String nik);

  Future<List<GolonganModel>> getCurrentGolongan(String nik);

  Future<bool> isAdmin(String nik);

  Future<List<EmployeeModel>?> getCurrentEmployee(String nik);
}

class AccountRemoteDatasourceImpl implements AccountRemoteDatasource {
  final InterceptedClient client;

  AccountRemoteDatasourceImpl(this.client);

  @override
  Future<AccountModel> getCurrentUser(String nik) async {
    try {
      final response = await client.post(
        Uri.parse(Api.profile),
        body: jsonEncode({
          "nik": nik,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return AccountModel.fromJson(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isAdmin(String nik) async {
    try {
      final response = await client.post(
        Uri.parse(Api.isAdmin),
        body: jsonEncode({
          "nik": nik,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      final res = jsonDecode(response.body);

      return res['data']['is_admin'] == 1;
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PositionModel>> getCurrentPosition(String nik) async {
    try {
      final response = await client.post(
        Uri.parse(Api.position),
        body: jsonEncode({
          "nik": nik,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return PositionModel.fromJsonList(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<GolonganModel>> getCurrentGolongan(String nik) async {
    try {
      final response = await client.post(
        Uri.parse(Api.golongan),
        body: jsonEncode({
          "nik": nik,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return GolonganModel.fromJsonList(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<EmployeeModel>?> getCurrentEmployee(String nik) async {
    try {
      final response = await client.post(
        Uri.parse("${Api.employee}/$nik"),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      if (response.body.isEmpty) return null;

      return EmployeeModel.fromJsonList(
          jsonDecode(response.body)['ZDATA']['item']);
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
