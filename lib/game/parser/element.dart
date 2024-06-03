// @dart=2.18

import 'action.dart';

class ElementParser {
  final String type;
  final String text;
  final int x;
  final int y;
  final bool centered;
  final ActionParser action;

  ElementParser({
    required this.type,
    required this.text,
    required this.x,
    required this.y,
    required this.centered,
    required this.action,
  });

  factory ElementParser.fromJson(Map<String, dynamic> json) {
    return ElementParser(
      type: json['type'],
      text: json['text'],
      x: json['x'],
      y: json['y'],
      centered: json['centered'],
      action: ActionParser.fromJson(json['action']),
    );
  }
}
