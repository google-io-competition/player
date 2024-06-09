import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../multiplayer/api_service.dart';
import '../multiplayer/firestore_controller.dart';
import '../multiplayer/websocket_service.dart';
import '../settings/settings.dart';
import 'lobby.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final TextEditingController _lobbyIdController = TextEditingController();
  String? _errorMessage;
  List<dynamic> lobbies = [];

  @override
  void initState() {
    super.initState();
    _fetchLobbies();
  }

  Future<void> _fetchLobbies() async {
    try {
      final apiService = context.read<ApiService>();
      final fetchedLobbies = await apiService.getLobbies();
      setState(() {
        lobbies = fetchedLobbies;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _joinLobby(String lobbyId) async {
    final apiService = context.read<ApiService>();
    final webSocketService = context.read<WebSocketService>();
    final firestoreController = FirestoreController(
      instance: FirebaseFirestore.instance,
      boardState: BoardState(element: BoardElement(text: '', duration: 0)),
    );
    final settingsController = context.read<SettingsController>();
    final userId = settingsController.displayName.value;

    try {
      await apiService.updateLobbyActivity(lobbyId);
      webSocketService.connect(lobbyId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LobbyScreen(
            lobbyId: lobbyId,
            userId: userId,
            firestoreController: firestoreController,
            webSocketService: webSocketService,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Lobby not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _lobbyIdController,
              decoration: InputDecoration(
                labelText: 'Enter Lobby ID',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final lobbyId = _lobbyIdController.text.trim();
                if (lobbyId.isNotEmpty) {
                  await _joinLobby(lobbyId);
                } else {
                  setState(() {
                    _errorMessage = 'Lobby ID cannot be empty';
                  });
                }
              },
              child: const Text('Join Lobby'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Available Lobbies:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: lobbies.length,
                itemBuilder: (context, index) {
                  final lobby = lobbies[index];
                  final lobbyId = lobby['id'];
                  return ListTile(
                    title: Text('Lobby ID: $lobbyId'),
                    onTap: () async {
                      await _joinLobby(lobbyId);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
