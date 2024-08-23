import 'package:easy/core/common/entities/employee.dart';

class EmployeeModel extends Employee {
  EmployeeModel({
    required super.nik,
    required super.nipp,
    required super.nikAtasan,
    required super.nama,
    required super.placeOfBirth,
    required super.dateOfBirth,
    required super.address,
    required super.ktp,
    required super.npwp,
    required super.startJabatan,
    required super.joinDate,
    required super.bacode,
    required super.baName,
    required super.unitCode,
    required super.unitName,
    required super.positionCode,
    required super.positionName,
    required super.jobCode,
    required super.jobName,
    required super.personGrade,
    required super.jobGrade,
    required super.codeContract,
    required super.contract,
    required super.genderCode,
    required super.gender,
    required super.religionCode,
    required super.religion,
    required super.marriedCode,
    required super.married,
    required super.marriedDate,
    super.mobile,
    super.changeOn,
    super.changeBy,
  });

  static EmployeeModel fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      nik: json['NIK'].toString(),
      nipp: json['NIPP'].toString(),
      nikAtasan: json['NIKATASAN'].toString(),
      nama: json['NAMA'].toString(),
      placeOfBirth: json['PLACEOFBIRTH'].toString(),
      dateOfBirth: json['DATEOFBIRTH'].toString(),
      address: json['ADDRESS'].toString(),
      mobile: json['MOBILE'].toString(),
      ktp: json['KTP'].toString(),
      npwp: json['NPWP'].toString(),
      startJabatan: json['STARTJABATAN'].toString(),
      joinDate: json['JOINDATE'].toString(),
      bacode: json['BACODE'].toString(),
      baName: json['BANAME'].toString(),
      unitCode: json['UNITCODE'].toString(),
      unitName: json['UNITNAME'].toString(),
      positionCode: json['POSITIONCODE'].toString(),
      positionName: json['POSITIONNAME'].toString(),
      jobCode: json['JOBCODE'].toString(),
      jobName: json['JOBNAME'].toString(),
      personGrade: json['PERSONGRADE'].toString(),
      jobGrade: json['JOBGRADE'].toString(),
      codeContract: json['CODECONTRACT'].toString(),
      contract: json['CONTRACT'].toString(),
      genderCode: json['GENDERCODE'].toString(),
      gender: json['GENDER'].toString(),
      religionCode: json['RELIGIONCODE'].toString(),
      religion: json['RELIGION'].toString(),
      marriedCode: json['MARRIEDCODE'].toString(),
      married: json['MARRIED'].toString(),
      marriedDate: json['MARRIEDDATE'].toString(),
      changeOn: json['CHANGEON'].toString(),
      changeBy: json['CHANGEBY'].toString(),
    );
  }

  static List<EmployeeModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e)).toList();
  }
}