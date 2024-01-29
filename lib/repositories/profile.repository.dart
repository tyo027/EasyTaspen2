import 'package:easy/models/golongan.model.dart';
import 'package:easy/models/jabatan.model.dart';
import 'package:easy/models/profile.model.dart';
import 'package:easy/repositories/repository.dart';

class ProfileRepository extends Repository {
  Future<ProfileModel?> getProfile({required String nik}) async {
    try {
      var response =
          await dio.post("InternalSDM/1.0/ApiIdentitas", data: {"nik": nik});
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<GolonganModel>?> getGolongan({required String nik}) async {
    try {
      var response =
          await dio.post("InternalSDM/1.0/ApiGolongan", data: {"nik": nik});
      return golonganModelFromJson(response.data);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<JabatanModel>?> getJabatan({required String nik}) async {
    try {
      var response =
          await dio.post("InternalSDM/1.0/ApiJabatan", data: {"nik": nik});
      return jabatanModelFromJson(response.data);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
