import 'package:equatable/equatable.dart';

class MppModel extends Equatable {
  final double long;
  final double lat;
  final double custom;

  const MppModel({
    required this.long,
    required this.lat,
    required this.custom,
  });

  static MppModel fromJson(Map<String, dynamic> json) => MppModel(
        long: double.parse(json['long'].toString()),
        lat: double.parse(json['lat'].toString()),
        custom: double.parse(json['custom'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'long': long.toString(),
        'lat': lat.toString(),
        'custom': lat.toString(),
      };
  // @override
  // String toString() {
  //   return "{'long': '$nik', 'NAMA': '$nama','JABATAN': '$jabatan','BA': '$ba','UNITKERJA': '$unitkerja'}";
  // }

  @override
  List<Object> get props => [
        long,
        lat,
        custom,
      ];
}
