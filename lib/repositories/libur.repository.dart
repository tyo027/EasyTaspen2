import 'package:easy/repositories/repository.dart';

class LiburRepository extends Repository {
  Future<bool> getIsLibur({required String tgl_merah}) async {
    try {
      var response = await dio.post("absensi/1.0/GetTanggalMerah", data: {
        "tgl_merah": tgl_merah,
      });
      //print(response.data);
      return response.data['data']['status'];
    } catch (e) {
      return false;
    }
  }
}
