import 'package:easy/models/authentication.model.dart';
import 'package:easy/models/location.model.dart';
import 'package:easy/models/mpp.model.dart';
import 'package:easy/models/rule.model.dart';
import 'package:easy/repositories/repository.dart';

class AuthenticationRepository extends Repository {
  Future<AuthenticationModel?> login(String username, String password) async {
    try {
      var response = await dio.post("loginAD/1.0/ApiLoginADPublic",
          data: {"username": username, "password": password});
      // print(response.data);

      return AuthenticationModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<LocationModel?> getCabangLocation(String kdCabang) async {
    try {
      var response = await dio.post(
        "absensi/1.0/DataCabangByKdCab/$kdCabang",
      );
      // print(response.data["result"][0]);
      return LocationModel.fromJson(response.data["result"][0]);
    } catch (e) {
      return null;
    }
  }

  Future<MppModel?> getMpp(String nik) async {
    try {
      var response =
          await dio.post("absensi/1.0/CekAbsenCustom", data: {"nik": nik});
      return MppModel.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<RuleModel?> getRules(String codeCabang) async {
    try {
      var response = await dio.post('absensi/1.0/rules/$codeCabang');

      return RuleModel.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }
}
