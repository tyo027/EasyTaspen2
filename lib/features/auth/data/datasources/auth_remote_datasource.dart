import 'dart:convert';

import 'package:easy/core/constants/api.dart';
import 'package:easy/features/auth/data/models/auth_model.dart';
import 'package:fca/fca.dart';
import 'package:http/http.dart' as http;
import 'package:easy/core/extension/string_extension.dart';

abstract interface class AuthRemoteDatasource {
  Future<AuthModel> signIn({
    required String username,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;

  AuthRemoteDatasourceImpl(
    this.client,
  );

  @override
  Future<AuthModel> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(Api.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      final res = jsonDecode(response.body);

      if (res['STATUSLOGIN'] == 0) {
        throw ResponseException(
            (res['TEXT'] as String).toUpperCaseFirstOfEachSentence());
      }

      final auth = AuthModel.fromJson(res);

      return auth;
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
