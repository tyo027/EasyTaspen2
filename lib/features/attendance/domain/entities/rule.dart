class Rule {
  final String name;
  final double long;
  final double lat;
  final int jarak;
  final bool isAllowWFH;
  final bool isAllowWFO;
  final bool isAllowMockLocation;

  Rule({
    required this.name,
    required this.long,
    required this.lat,
    required this.jarak,
    required this.isAllowWFH,
    required this.isAllowWFO,
    required this.isAllowMockLocation,
  });
}
