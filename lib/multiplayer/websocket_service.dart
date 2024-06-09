import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? channel;

  void connect(String lobbyId) {
    final url = 'ws://game-master.web.app:8080/ws/lobby/$lobbyId';
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel!.stream.listen((message) {
      // Handle received messages
      print('Received: $message');
      // Update the UI or game state accordingly
    }, onDone: () {
      print('WebSocket closed');
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  void sendMessage(String message) {
    channel?.sink.add(message);
  }

  void disconnect() {
    channel?.sink.close();
  }
}