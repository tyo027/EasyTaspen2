class Employee {
  final String nik;
  final String nipp;
  final String nikAtasan;
  final String nama;
  final String placeOfBirth;
  final String dateOfBirth;
  final String address;
  final String? mobile;
  final String ktp;
  final String npwp;
  final String startJabatan;
  final String joinDate;
  final String bacode;
  final String baName;
  final String unitCode;
  final String unitName;
  final String positionCode;
  final String positionName;
  final String jobCode;
  final String jobName;
  final String personGrade;
  final String jobGrade;
  final String codeContract;
  final String contract;
  final String genderCode;
  final String gender;
  final String religionCode;
  final String religion;
  final String marriedCode;
  final String married;
  final String marriedDate;
  final String? changeOn;
  final String? changeBy;

  Employee({
    required this.nik,
    required this.nipp,
    required this.nikAtasan,
    required this.nama,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.address,
    this.mobile,
    required this.ktp,
    required this.npwp,
    required this.startJabatan,
    required this.joinDate,
    required this.bacode,
    required this.baName,
    required this.unitCode,
    required this.unitName,
    required this.positionCode,
    required this.positionName,
    required this.jobCode,
    required this.jobName,
    required this.personGrade,
    required this.jobGrade,
    required this.codeContract,
    required this.contract,
    required this.genderCode,
    required this.gender,
    required this.religionCode,
    required this.religion,
    required this.marriedCode,
    required this.married,
    required this.marriedDate,
    this.changeOn,
    this.changeBy,
  });
}
