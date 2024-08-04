import 'package:easy/models/cekstaff.model.dart';
import 'package:easy/repositories/repository.dart';

class CekStaff extends Repository {
  Future<List<CekStaffModel>> getStaff({required String nik}) async {
    try {
      var response = await dio.post(
        "absensi/1.0/employeeBawahan/$nik",
      );
      //print("absensi/1.0/employeeBawahan/$nik");
      if (response.data.toString().isEmpty) {
        return [];
      }
      return cekStaffModelFromJson(response.data["ZDATA"]["item"]);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
