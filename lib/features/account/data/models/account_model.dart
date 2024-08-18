import 'package:easy/features/account/domain/entities/account.dart';

class AccountModel extends Account {
  AccountModel({
    required super.name,
    required super.gender,
    required super.position,
    required super.unit,
    required super.address,
    required super.birthPlace,
    required super.birthDate,
    required super.marital,
    required super.religion,
    required super.school,
    required super.strata,
    required super.blood,
    required super.area,
    required super.grade,
    required super.ktp,
    required super.jamsostek,
    required super.npwp,
    required super.tmt,
    required super.work,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['identity']['Name'] ?? '-',
      gender: json['identity']['Gender'] ?? '-',
      address: json['identity']['Alamat'] ?? '-',
      birthPlace: json['identity']['Birthplace'] ?? '-',
      birthDate: json['identity']['Birthdate'] ?? '-',
      marital: json['identity']['Marital'] ?? '-',
      religion: json['identity']['Religion'] ?? '-',
      school: json['identity']['School'] ?? '-',
      strata: json['identity']['Strata'] ?? '-',
      blood: json['identity']['Blood'] ?? '-',
      area: json['identity']['Area'] ?? '-',
      grade: json['identity']['Grage'] ?? '-',
      ktp: json['identity']['Ktp'] ?? '-',
      jamsostek: json['identity']['Jamsostek'] ?? '-',
      npwp: json['identity']['Npwp'] ?? '-',
      position: json['identity']['Position'] ?? '-',
      tmt: json['identity']['Tmt'] ?? '-',
      unit: json['identity']['Unit'] ?? '-',
      work: json['identity']['Work'] ?? '-',
    );
  }
}
