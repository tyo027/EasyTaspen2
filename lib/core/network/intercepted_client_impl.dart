import 'package:fca/fca.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InterceptedClientImpl extends InterceptedClient {
  Box box;

  InterceptedClientImpl({
    required super.client,
    required this.box,
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
  Future<void> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
