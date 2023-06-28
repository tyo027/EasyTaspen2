import 'package:easy/models/golongan.model.dart';
import 'package:easy/models/jabatan.model.dart';
import 'package:easy/models/profile.model.dart';
import 'package:easy/repositories/repository.dart';

class ProfileRepository extends Repository {
  Future<ProfileModel?> getProfile({required String nik}) async {
    try {
      var response = await dio.get("v2/GetIdentitas/$nik");
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<GolonganModel>?> getGolongan({required String nik}) async {
    try {
      var response = await dio.get("v2/GetGolongan/$nik");
      return golonganModelFromJson(response.data);
    } catch (e) {
      return [];
    }
  }

  Future<List<JabatanModel>?> getJabatan({required String nik}) async {
    try {
      var response = await dio.get("v2/GetJabatan/$nik");
      return jabatanModelFromJson(response.data);
    } catch (e) {
      return [];
    }
  }
}
