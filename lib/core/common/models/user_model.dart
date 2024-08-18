import 'package:easy/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.nik,
    required super.nama,
    required super.jabatan,
    required super.ba,
    required super.unitKerja,
    required super.perty,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nik: json['nik'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      ba: json['ba'],
      unitKerja: json['unitKerja'],
      perty: json['perty'],
    );
  }

  Map toJson() {
    return {
      "nik": nik,
      "nama": nama,
      "jabatan": jabatan,
      "ba": ba,
      "unitKerja": unitKerja,
      "perty": perty,
    };
  }
}
