import 'package:easy/repositories/repository.dart';

class PaySlipRepository extends Repository {
  Future<String?> paySlipRepository(
      {required String nik, required String thnbln}) async {
    try {
      var response = await dio.get("v2/GetGaji/$nik/$thnbln");

      return response.data;
    } catch (e) {
      return null;
    }
  }
}
