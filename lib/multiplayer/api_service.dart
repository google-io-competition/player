import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> listLobbies() async {
    final response = await http.get(Uri.parse('$baseUrl/lobbies'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['lobbies'];
    } else {
      throw Exception('Failed to load lobbies');
    }
  }

  Future<String> createLobby(Map<String, dynamic> game) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lobbies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'game': game, 'is_public': true}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['lobby_id'];
    } else {
      throw Exception('Failed to create lobby');
    }
  }
}
