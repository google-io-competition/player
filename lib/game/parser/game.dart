// @dart=2.18

import 'state.dart';
import 'asset.dart';

class GameParser {
  final String name;
  final int version;
  final String author;
  final int maxPlayers;
  final int minPlayers;
  final List<StateParser> states;
  final List<AssetParser> assets;

  GameParser({
    required this.name,
    required this.version,
    required this.author,
    required this.maxPlayers,
    required this.minPlayers,
    required this.states,
    required this.assets,
  });

  factory GameParser.fromJson(Map<String, dynamic> json) {
    return GameParser(
      name: json['name'],
      version: json['version'],
      author: json['author'],
      maxPlayers: json['max-players'],
      minPlayers: json['min-players'],
      states: (json['states'] as List).map((i) => StateParser.fromJson(i)).toList(),
      assets: (json['assets'] as List).map((i) => AssetParser.fromJson(i)).toList(),
    );
  }
}
