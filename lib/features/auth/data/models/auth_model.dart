import 'package:easy/features/auth/domain/entity/auth.dart';

class AuthModel extends Auth {
  AuthModel({
    required super.nik,
    required super.nama,
    required super.jabatan,
    required super.ba,
    required super.unitKerja,
    required super.perty,
    required super.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      nik: json['status']['NIK'],
      nama: json['status']['NAMA'],
      jabatan: json['status']['JABATAN'],
      ba: json['status']['BA'],
      unitKerja: json['status']['UNITKERJA'],
      perty: json['status']['PERTY'],
      token: json['_token'],
    );
  }
}
