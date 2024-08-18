import 'dart:convert';

import 'package:easy/core/common/models/user_model.dart';
import 'package:easy/core/constants/constants.dart';
import 'package:easy/core/utils/secure.dart';
import 'package:easy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fca/fca.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class InterceptedClientImpl extends InterceptedClient {
  Box box;
  AuthRemoteDatasource authRemoteDatasource;

  InterceptedClientImpl({
    required super.client,
    required this.box,
    required this.authRemoteDatasource,
    super.authorizationType = 'Bearer',
  });

  @override
  String modifyJsonResponse(String responseBody) {
    return responseBody;
  }

  @override
  Future<String> getToken() async {
    final token = box.get('token');
    if (token == null) {
      throw Exception('No Token');
    }
    return token;
  }

  @override
  Future<void> refreshToken() async {
    final secureUsername = box.get('username');
    final securePassword = box.get('password');

    if (secureUsername == null || securePassword == null) {
      throw Failure(Constants.unAuthenticated);
    }

    final username = Secure.unSecureText(secureUsername);
    final password = Secure.unSecureText(securePassword);

    final auth = await authRemoteDatasource.signIn(
      username: username,
      password: password,
    );

    final user = UserModel.fromJson(jsonDecode(box.get('user')));

    await box.put('token', auth.token);
    await box.put('username', Secure.secureText(username));
    await box.put('password', Secure.secureText(password));
    await box.put('user', jsonEncode(user.toJson()));
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      // Add the Authorization header with the current token
      request.headers['Authorization'] =
          '$authorizationType ${await getToken()}';
      request.headers['Content-Type'] = 'application/json';

      final response = await client.send(request);

      return transforms(response);
    } on http.ClientException catch (e) {
      if (e.message == 'Failed to parse header value') {
        await refreshToken();
        final newRequest = http.Request(request.method, request.url)
          ..headers.addAll(request.headers)
          ..headers['Authorization'] = '$authorizationType ${await getToken()}'
          ..body = (request as http.Request).body;

        final newResponse = await client.send(newRequest);

        return transforms(newResponse);
      }

      rethrow;
    }
  }
}
