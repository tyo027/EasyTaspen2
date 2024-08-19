import 'dart:convert';

import 'package:easy/core/constants/api.dart';
import 'package:easy/features/attendance/data/models/mpp_model.dart';
import 'package:easy/features/attendance/data/models/rule_model.dart';
import 'package:fca/fca.dart';

abstract interface class AttendanceRemoteDatasource {
  Future<RuleModel> getRule(String codeCabang);
  Future<MppModel> getMpp(String nik);
}

class AttendanceRemoteDatasourceImpl implements AttendanceRemoteDatasource {
  InterceptedClient client;

  AttendanceRemoteDatasourceImpl(this.client);

  @override
  Future<RuleModel> getRule(String codeCabang) async {
    try {
      final response = await client.post(
        Uri.parse("${Api.rule}/$codeCabang"),
      );

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return RuleModel.fromJson(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MppModel> getMpp(String nik) async {
    try {
      final response =
          await client.post(Uri.parse(Api.mpp), body: jsonEncode({"nik": nik}));

      if (response.statusCode != 200) {
        throw ResponseException(response.body);
      }

      return MppModel.fromJson(jsonDecode(response.body));
    } on ResponseException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
