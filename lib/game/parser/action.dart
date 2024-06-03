// @dart=2.18

class ActionParser {
  final String type;
  final String route;

  ActionParser({
    required this.type,
    required this.route,
  });

  factory ActionParser.fromJson(Map<String, dynamic> json) {
    return ActionParser(
      type: json['type'],
      route: json['route'],
    );
  }
}
