import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  static const String baseUrl = 'http://localhost:8080';

  Future<void> createLobby(String lobbyId) async {
    final response =
        await client.post(Uri.parse('$baseUrl/create_lobby/$lobbyId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to create lobby');
    }
  }
}
