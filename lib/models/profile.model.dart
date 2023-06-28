import 'package:equatable/equatable.dart';

profileModelFromJson(List<dynamic> list) =>
    List<ProfileModel>.from(list.map((json) => ProfileModel.fromJson(json)));

class ProfileModel extends Equatable {
  final String alamat;
  final String area;
  final String birthdate;
  final String birthplace;
  final String blood;
  final String gender;
  final String grade;
  final String jamsostek;
  final String ktp;
  final String marital;
  final String name;
  final String npwp;
  final String position;
  final String religion;
  final String school;
  final String strata;
  final String tmt;
  final String unit;
  final String work;

  const ProfileModel({
    required this.alamat,
    required this.area,
    required this.birthdate,
    required this.birthplace,
    required this.blood,
    required this.gender,
    required this.grade,
    required this.jamsostek,
    required this.ktp,
    required this.marital,
    required this.name,
    required this.npwp,
    required this.position,
    required this.religion,
    required this.school,
    required this.strata,
    required this.tmt,
    required this.unit,
    required this.work,
  });

  static ProfileModel fromJson(Map<String, dynamic> json) => ProfileModel(
        alamat: json['Alamat'],
        area: json['Area'],
        birthdate: json['Birthdate'],
        birthplace: json['Birthplace'],
        blood: json['Blood'],
        gender: json['Gender'],
        grade: json['Grade'],
        jamsostek: json['Jamsostek'],
        ktp: json['Ktp'],
        marital: json['Marital'],
        name: json['Name'],
        npwp: json['Npwp'],
        position: json['Position'],
        religion: json['Religion'],
        school: json['School'],
        strata: json['Strata'],
        tmt: json['Tmt'],
        unit: json['Unit'],
        work: json['Work'],
      );

  @override
  List<Object> get props => [
        alamat,
        area,
        birthdate,
        birthplace,
        blood,
        gender,
        grade,
        jamsostek,
        ktp,
        marital,
        name,
        npwp,
        position,
        religion,
        school,
        strata,
        tmt,
        unit,
        work,
      ];
}
