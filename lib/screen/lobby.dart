import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../multiplayer/firestore_controller.dart';
import '../multiplayer/websocket_service.dart';
import 'chat.dart';

class LobbyScreen extends StatelessWidget {
  final String lobbyId;
  final String userId;
  final FirestoreController firestoreController;
  final WebSocketService webSocketService;

  const LobbyScreen({super.key,
    required this.lobbyId,
    required this.userId,
    required this.firestoreController,
    required this.webSocketService,
  });

  @override
  Widget build(BuildContext context) {
    webSocketService.connect(lobbyId);

    return Scaffold(
      appBar: AppBar(title: Text('Lobby $lobbyId')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: webSocketService.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                } else {
                  return const Text('No data received yet');
                }
              },
            ),
          ),
          TextField(
            onSubmitted: (message) {
              webSocketService.send(message);
            },
            decoration: InputDecoration(
              labelText: 'Send a message',
            ),
          ),
        ],
      ),
    );
  }
}