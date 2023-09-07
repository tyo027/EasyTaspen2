import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String nik;
  final String nama;
  final String jabatan;
  final String ba;
  final String unitkerja;
  final String gender;
  final bool isActive;
  final double latitude;
  final double longitude;
  final bool allowWFA;
  final bool allowWFO;
  final bool allowMock;
  final int radius;

  const UserModel(
      {required this.nik,
      required this.nama,
      required this.jabatan,
      required this.ba,
      required this.unitkerja,
      this.gender = "",
      required this.isActive,
      this.latitude = 0,
      this.longitude = 0,
      this.allowWFA = false,
      this.allowWFO = false,
      this.allowMock = false,
      this.radius = 0});

  UserModel copyWith(
          {String? nik,
          String? nama,
          String? jabatan,
          String? ba,
          String? unitkerja,
          String? gender,
          bool? isActive,
          double? latitude,
          double? longitude,
          bool? allowWFA,
          bool? allowWFO,
          bool? allowMock,
          int? radius}) =>
      UserModel(
          nik: nik ?? this.nik,
          nama: nama ?? this.nama,
          jabatan: jabatan ?? this.jabatan,
          ba: ba ?? this.ba,
          unitkerja: unitkerja ?? this.unitkerja,
          gender: gender ?? this.gender,
          isActive: isActive ?? this.isActive,
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.latitude,
          allowWFA: allowWFA ?? this.allowWFA,
          allowWFO: allowWFO ?? this.allowWFO,
          allowMock: allowMock ?? this.allowMock,
          radius: radius ?? this.radius);

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        nik: json['NIK'],
        nama: json['NAMA'],
        jabatan: json['JABATAN'],
        ba: json['BA'],
        unitkerja: json['UNITKERJA'],
        gender: json['Gender'],
        isActive: json.containsKey("IS_ACTIVE") ? json["IS_ACTIVE"] : true,
        latitude: json.containsKey("latitude") ? json["latitude"] : 0,
        longitude: json.containsKey("longitude") ? json["longitude"] : 0,
        allowWFA: json.containsKey("allowWFA") ? json["allowWFA"] : false,
        allowWFO: json.containsKey("allowWFO") ? json["allowWFO"] : false,
        allowMock: json.containsKey("allowMock") ? json["allowMock"] : false,
        radius: json.containsKey("radius") ? json["radius"] : 0,
      );

  Map<String, dynamic> toJson() => {
        'NIK': nik,
        'NAMA': nama,
        'JABATAN': jabatan,
        'BA': ba,
        'UNITKERJA': unitkerja,
        'Gender': gender,
        "IS_ACTIVE": isActive,
        "latitude": latitude,
        "longitude": longitude,
        "allowWFA": allowWFA,
        "allowWFO": allowWFO,
        "allowMock": allowMock,
        "radius": radius
      };

  @override
  List<Object?> get props => [
        nik,
        nama,
        jabatan,
        ba,
        unitkerja,
        gender,
        isActive,
        latitude,
        longitude,
        allowWFA,
        allowWFO,
        allowMock,
        radius
      ];
}
