import 'package:easy/repositories/repository.dart';

class AdminRepository extends Repository {
  Future<String?> adminRepository({
    required String username,
  }) async {
    var response = await dio.post("v2/DeleteDeviceId/$username");
    return response.data["message"];
  }
}
