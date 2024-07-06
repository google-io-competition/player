import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:player/game/game_models.dart';

class LocalFileStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<GameFile?> readGame(String fileName) async {
    try {
      String? value = await _storage.read(key: fileName);

      if (value != null && value.isNotEmpty) {
        final json = jsonDecode(value) as Map<String, dynamic>;

        return GameFile.fromJson(json);
      } else {
        print('Game does not exist, creating a new one');

        GameFile defaultGame = await loadDefaultGame();

        await writeGame(fileName, defaultGame);

        return defaultGame;
      }
    } catch (e) {
      print('Error reading game file: $e');
    }
    return null;
  }

  Future<void> writeGame(String fileName, GameFile game) async {
    final json = jsonEncode(game.toJson());

    await _storage.write(key: fileName, value: json);
  }
}