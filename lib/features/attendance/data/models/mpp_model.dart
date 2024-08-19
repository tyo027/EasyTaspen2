class MppModel {
  final bool isCustom;
  final double long;
  final double lat;
  final int radius;

  MppModel({
    required this.isCustom,
    required this.long,
    required this.lat,
    required this.radius,
  });

  factory MppModel.fromJson(Map<String, dynamic> json) {
    return MppModel(
      isCustom: json['data']['custom'] == 1,
      long: double.tryParse(json['data']['long'].toString()) ?? 0,
      lat: double.tryParse(json['data']['lat'].toString()) ?? 0,
      radius: json['data']['radius'],
    );
  }
}
