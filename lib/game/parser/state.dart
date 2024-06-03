// @dart=2.18

import 'element.dart';

class StateParser {
  final String route;
  final int duration;
  final List<ElementParser> elements;

  StateParser({
    required this.route,
    required this.duration,
    required this.elements,
  });

  factory StateParser.fromJson(Map<String, dynamic> json) {
    return StateParser(
      route: json['route'],
      duration: json['duration'],
      elements: (json['elements'] as List).map((i) => ElementParser.fromJson(i)).toList(),
    );
  }
}
