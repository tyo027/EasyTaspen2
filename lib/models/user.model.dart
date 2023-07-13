import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String nik;
  final String nama;
  final String jabatan;
  final String ba;
  final String unitkerja;
  final String? gender;
  final bool isActive;

  const UserModel(
      {required this.nik,
      required this.nama,
      required this.jabatan,
      required this.ba,
      required this.unitkerja,
      this.gender,
      required this.isActive});

  UserModel copyWith(
          {String? nik,
          String? nama,
          String? jabatan,
          String? ba,
          String? unitkerja,
          String? gender,
          bool? isActive}) =>
      UserModel(
          nik: nik ?? this.nik,
          nama: nama ?? this.nama,
          jabatan: jabatan ?? this.jabatan,
          ba: ba ?? this.ba,
          unitkerja: unitkerja ?? this.unitkerja,
          gender: gender ?? this.gender,
          isActive: isActive ?? this.isActive);

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      nik: json['NIK'],
      nama: json['NAMA'],
      jabatan: json['JABATAN'],
      ba: json['BA'],
      unitkerja: json['UNITKERJA'],
      gender: json['Gender'],
      isActive: json.containsKey("IS_ACTIVE") ? json["IS_ACTIVE"] : true);

  Map<String, dynamic> toJson() => {
        'NIK': nik,
        'NAMA': nama,
        'JABATAN': jabatan,
        'BA': ba,
        'UNITKERJA': unitkerja,
        'Gender': gender,
        "IS_ACTIVE": isActive
      };
  // @override
  // String toString() {
  //   return "{'NIK': '$nik', 'NAMA': '$nama','JABATAN': '$jabatan','BA': '$ba','UNITKERJA': '$unitkerja'}";
  // }

  @override
  List<Object?> get props =>
      [nik, nama, jabatan, ba, unitkerja, gender, isActive];
}
