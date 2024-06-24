import 'dart:convert';

import 'package:http/http.dart' as http;

import '../game/game_models.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  static const String baseUrl = 'https://game-master.web.app/api';

  Future<void> createLobby(String lobbyId) async {
    final response =
    await client.post(Uri.parse('$baseUrl/create_lobby/$lobbyId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to create lobby');
    }
  }

  Future<PaginatedResponse> fetchPaginatedList(int page) async {
    final response = await client.get(Uri.parse('$baseUrl/list/$page'));

    if (response.statusCode == 200) {
      return PaginatedResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch paginated list');
    }
  }


  Future<PaginatedResponse> searchPaginatedList(int page, String query) async {
    final uri = Uri.parse('$baseUrl/search/$page')
        .replace(queryParameters: {'query': query});

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return PaginatedResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch search results');
    }
  }
}