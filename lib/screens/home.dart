import 'dart:math';

import 'package:flutter/material.dart';

import '../api/api_service.dart';
import 'lobby_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _lobbyIdController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  void _joinLobby() {
    final lobbyId = _lobbyIdController.text;
    final displayName = _displayNameController.text;

    if (lobbyId.isNotEmpty && displayName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LobbyScreen(lobbyId: lobbyId, displayName: displayName),
        ),
      );
    } else {
      // Show error if inputs are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both Lobby ID and Display Name')),
      );
    }
  }

  void _createLobby() async {
    final displayName = _displayNameController.text;

    if (displayName.isNotEmpty) {
      final lobbyId = _generateRandomLobbyId();
      try {
        print('Creating lobby $lobbyId');
        await ApiService().createLobby(lobbyId).then((_) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LobbyScreen(lobbyId: lobbyId, displayName: displayName),
                ),
              )
            });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create lobby: $e')),
        );
      }
    } else {
      // Show error if display name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a Display Name')),
      );
    }
  }

  String _generateRandomLobbyId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join or Create a Lobby'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _lobbyIdController,
              decoration: InputDecoration(labelText: 'Lobby ID'),
            ),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinLobby,
              child: Text('Join Lobby'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createLobby,
              child: Text('Create Lobby'),
            ),
          ],
        ),
      ),
    );
  }
}
