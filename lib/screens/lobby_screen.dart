import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/ws_service.dart';
import '../widgets/message_input.dart';

class LobbyScreen extends StatefulWidget {
  final String lobbyId;
  final String displayName;

  LobbyScreen({super.key, required this.lobbyId, required this.displayName});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    connectWebSocket();
  }

  void connectWebSocket() {
    _webSocketService.connect(
      widget.lobbyId,
      widget.displayName,
      (message) {
        print('Message received: $message');
      },
      () {
      },
    );
  }

  @override
  void dispose() {
    _webSocketService.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _webSocketService.sendMessage(_controller.text);
      _controller.text = '';
    }
  }

  void _startGame() {
    _webSocketService.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _webSocketService,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lobby: ${widget.lobbyId}'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<WebSocketService>(
                builder: (context, service, child) {
                  return ListView.builder(
                    itemCount: service.chatMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(service.chatMessages[index]),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Display Name: ${widget.displayName}'),
                  Text('Lobby ID: ${widget.lobbyId}'),
                  Consumer<WebSocketService>(
                    builder: (context, service, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Players:'),
                          ...service.players
                              .map((player) => Text(player.displayName))
                              .toList(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            MessageInput(controller: _controller, sendMessage: _sendMessage),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _startGame,
          tooltip: 'Start Game',
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
