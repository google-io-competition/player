// @dart=2.18

class AssetParser {
  final String type;
  final String location;

  AssetParser({
    required this.type,
    required this.location,
  });

  factory AssetParser.fromJson(Map<String, dynamic> json) {
    return AssetParser(
      type: json['type'],
      location: json['location'],
    );
  }
}
