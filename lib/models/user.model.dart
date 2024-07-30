import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String nik;
  final String nama;
  final String jabatan;
  final String ba;
  final String unitkerja;
  final String? perty;
  final String gender;
  final bool isActive;
  final double latitude;
  final double longitude;
  final bool allowWFA;
  final bool allowWFO;
  final bool allowMock;
  final int radius;
  final bool isAdmin;

  const UserModel(
      {required this.nik,
      required this.nama,
      required this.jabatan,
      required this.ba,
      required this.unitkerja,
      required this.perty,
      this.gender = "",
      required this.isActive,
      this.latitude = 0,
      this.longitude = 0,
      this.allowWFA = false,
      this.allowWFO = false,
      this.allowMock = false,
      this.radius = 0,
      this.isAdmin = false});

  UserModel copyWith(
          {String? nik,
          String? nama,
          String? jabatan,
          String? ba,
          String? unitkerja,
          String? perty,
          String? gender,
          bool? isActive,
          double? latitude,
          double? longitude,
          bool? allowWFA,
          bool? allowWFO,
          bool? allowMock,
          int? radius,
          bool? isAdmin}) =>
      UserModel(
          nik: nik ?? this.nik,
          nama: nama ?? this.nama,
          jabatan: jabatan ?? this.jabatan,
          ba: ba ?? this.ba,
          unitkerja: unitkerja ?? this.unitkerja,
          perty: perty ?? this.perty,
          gender: gender ?? this.gender,
          isActive: isActive ?? this.isActive,
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.longitude,
          allowWFA: allowWFA ?? this.allowWFA,
          allowWFO: allowWFO ?? this.allowWFO,
          allowMock: allowMock ?? this.allowMock,
          radius: radius ?? this.radius,
          isAdmin: isAdmin ?? this.isAdmin);

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        nik: json['NIK'],
        nama: json['NAMA'],
        jabatan: json['JABATAN'],
        ba: json['BA'],
        unitkerja: json['UNITKERJA'],
        perty: json['PERTY'],
        gender: json.containsKey("Gender") ? json['Gender'] : "",
        isActive: json.containsKey("IS_ACTIVE") ? json["IS_ACTIVE"] : true,
        latitude: json.containsKey("latitude") ? json["latitude"] : 0,
        longitude: json.containsKey("longitude") ? json["longitude"] : 0,
        allowWFA: json.containsKey("allowWFA") ? json["allowWFA"] : false,
        allowWFO: json.containsKey("allowWFO") ? json["allowWFO"] : false,
        allowMock: json.containsKey("allowMock") ? json["allowMock"] : false,
        radius: json.containsKey("radius") ? json["radius"] : 0,
        isAdmin: json.containsKey("isAdmin") ? json["isAdmin"] : false,
      );

  Map<String, dynamic> toJson() => {
        'NIK': nik,
        'NAMA': nama,
        'JABATAN': jabatan,
        'BA': ba,
        'UNITKERJA': unitkerja,
        'PERTY': perty,
        'Gender': gender,
        "IS_ACTIVE": isActive,
        "latitude": latitude,
        "longitude": longitude,
        "allowWFA": allowWFA,
        "allowWFO": allowWFO,
        "allowMock": allowMock,
        "radius": radius,
        "isAdmin": isAdmin,
      };

  @override
  List<Object?> get props => [
        nik,
        nama,
        jabatan,
        ba,
        unitkerja,
        perty,
        gender,
        isActive,
        latitude,
        longitude,
        allowWFA,
        allowWFO,
        allowMock,
        radius,
        isAdmin
      ];
}
