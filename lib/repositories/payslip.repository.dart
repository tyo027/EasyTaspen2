import 'package:easy/repositories/repository.dart';

class PaySlipRepository extends Repository {
  Future<String?> paySlipRepository(
      {required String nik, required String thnbln}) async {
    try {
      var response = await dio.post("InternalSDM/1.0/ApiGaji",
          data: {"nik": nik, "thnbln": thnbln});

      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
