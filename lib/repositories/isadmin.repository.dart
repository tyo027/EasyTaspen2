import 'package:easy/repositories/repository.dart';

class IsAdminRepository extends Repository {
  Future<bool> getIsAdmin({required String nik}) async {
    try {
      var response = await dio.post("absensi/1.0/GetUserAdmin", data: {
        "nik": nik,
      });
      //print(response.data);
      return response.data['data']['status'];
    } catch (e) {
      return false;
    }
  }
}
