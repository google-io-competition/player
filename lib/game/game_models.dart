class Game {
  String name;
  String type;
  int minPlayers;
  int maxPlayers;
  String author;
  String description;
  String icon;

  Game({
    required this.name,
    required this.type,
    required this.minPlayers,
    required this.maxPlayers,
    required this.author,
    required this.description,
    required this.icon,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      type: json['type'],
      minPlayers: json['min-players'],
      maxPlayers: json['max-players'],
      author: json['author'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class File {
  String fileName;
  Game content;

  File({
    required this.fileName,
    required this.content,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      fileName: json['file_name'],
      content: Game.fromJson(json['content']),
    );
  }
}

class PaginatedResponse {
  int page;
  int totalFiles;
  List<File> files;

  PaginatedResponse({
    required this.page,
    required this.totalFiles,
    required this.files,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    var filesJson = json['files'] as List;
    List<File> filesList = filesJson.map((fileJson) => File.fromJson(fileJson)).toList();

    return PaginatedResponse(
      page: json['page'],
      totalFiles: json['total_files'],
      files: filesList,
    );
  }
}