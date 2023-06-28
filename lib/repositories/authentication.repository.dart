import 'package:easy/models/authentication.model.dart';
import 'package:easy/models/location.model.dart';
import 'package:easy/repositories/repository.dart';

class AuthenticationRepository extends Repository {
  Future<AuthenticationModel?> login(String userName, String password) async {
    try {
      var response = await dio.post("loginADNoToken",
          data: {"username": userName, "password": password});

      return AuthenticationModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<LocationModel?> getCabangLocation(String kdCabang) async {
    try {
      var response = await dio.post(
        "GetDataCabangByKdcab?kdcab=$kdCabang",
      );
      // print(response.data["result"][0]);
      return LocationModel.fromJson(response.data["result"][0]);
    } catch (e) {
      return null;
    }
  }
}
