class User {
  final String nik;
  final String nama;
  final String jabatan;
  final String ba;
  final String unitKerja;
  final String perty;
  final bool isAdmin;

  User({
    required this.nik,
    required this.nama,
    required this.jabatan,
    required this.ba,
    required this.unitKerja,
    required this.perty,
    required this.isAdmin,
  });

  bool get canAccess => !["BOD", "BOC", "SBOC"].contains(perty);
}
