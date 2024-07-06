import 'dart:convert';

import 'package:flutter/services.dart';

class Screen {
  Map<String, dynamic> jsonContent;
  Map<String, dynamic> variables;

  Screen({
    required this.jsonContent,
    required this.variables,
  });

  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      jsonContent: json['jsonContent'],
      variables: json['variables'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jsonContent': jsonContent,
      'variables': variables,
    };
  }
}

class Game {
  String name;
  String type;
  int minPlayers;
  int maxPlayers;
  String author;
  String description;
  String icon;
  Map<String, Screen> screens;

  Game({
    required this.name,
    required this.type,
    required this.minPlayers,
    required this.maxPlayers,
    required this.author,
    required this.description,
    required this.icon,
    required this.screens,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      type: json['type'],
      minPlayers: json['minPlayers'],
      maxPlayers: json['maxPlayers'],
      author: json['author'],
      description: json['description'],
      icon: json['icon'],
      screens: Map<String, Screen>.from(json['screens']
          .map((key, value) => MapEntry(key, Screen.fromJson(value)))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'author': author,
      'description': description,
      'icon': icon,
      'screens': screens.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class GameFile {
  String fileName;
  Game content;

  GameFile({
    required this.fileName,
    required this.content,
  });

  factory GameFile.fromJson(Map<String, dynamic> json) {
    return GameFile(
      fileName: json['fileName'],
      content: Game.fromJson(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'content': content.toJson(),
    };
  }
}

class PaginatedResponse {
  int page;
  int totalFiles;
  List<GameFile> files;

  PaginatedResponse({
    required this.page,
    required this.totalFiles,
    required this.files,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    var filesJson = json['files'] as List;
    List<GameFile> filesList =
    filesJson.map((fileJson) => GameFile.fromJson(fileJson)).toList();

    return PaginatedResponse(
      page: json['page'],
      totalFiles: json['totalFiles'],
      files: filesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'totalFiles': totalFiles,
      'files': files.map((file) => file.toJson()).toList(),
    };
  }
}

Future<GameFile> loadDefaultGame() async {
  final String homeJson = await rootBundle.loadString('assets/pages/home.json');
  final String endJson = await rootBundle.loadString('assets/pages/home.json');
  final Map<String, dynamic> home = jsonDecode(homeJson);
  final Map<String, dynamic> end = jsonDecode(endJson);

  return GameFile(
    fileName: 'current.json',
    content: Game(
      name: '',
      type: '',
      minPlayers: 1,
      maxPlayers: 8,
      author: '',
      description: '',
      icon: '',
      screens: {
        'home': Screen(variables: {}, jsonContent: home),
        'end': Screen(variables: {}, jsonContent: end)
      },
    ),
  );
}