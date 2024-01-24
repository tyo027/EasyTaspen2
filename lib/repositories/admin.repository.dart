import 'package:easy/repositories/repository.dart';

class AdminRepository extends Repository {
  Future<String?> adminRepository({
    required String username,
  }) async {
    var response = await dio.post("absensi/1.0/DeleteDeviceId/$username");
    return response.data["message"];
  }
}
