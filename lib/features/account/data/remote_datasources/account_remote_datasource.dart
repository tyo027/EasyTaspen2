import 'dart:convert';

import 'package:easy/core/constants/api.dart';
import 'package:fca/fca.dart';

abstract interface class AccountRemoteDatasource {
  Future<void> getCurrentUser(String nik);

  Future<bool> isAdmin(String nik);
}

class AccountRemoteDatasourceImpl implements AccountRemoteDatasource {
  final InterceptedClient client;

  AccountRemoteDatasourceImpl(this.client);

  @override
  Future<void> getCurrentUser(String nik) async {
    try {
      final response = await client.post(
        Uri.parse(Api.profile),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nik": nik,
        }),
      );

      print(response.body);

      // if (response.statusCode != 200) {
      //   throw ResponseException(response.body);
      // }

      // final res = jsonDecode(response.body);

      // print(res);
      // // return;
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nik": nik,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      final res = jsonDecode(response.body);

      return res['data']['is_admin'] == "1";
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
