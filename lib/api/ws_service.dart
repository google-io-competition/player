import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum MessageType { CONNECT, CHECK_PLAYERS, START_GAME, END_GAME, CUSTOM, TEXT }

class Player {
  String id;
  String displayName;

  Player(this.id, this.displayName);

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(json['id'], json['displayName']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'displayName': displayName};
  }
}

class WebSocketService extends ChangeNotifier {
  late WebSocketChannel _channel;
  late String playerId;
  List<Player> players = [];
  List<String> chatMessages = [];
  Map<String, List<String>> dms = {};

  late Function onGameStart;
  late Function onGameEnd;

  void connect(String lobbyId, String displayName, Function(String) onMessage,
      Function onGameStart) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/ws/lobby'),
    );
    this.onGameStart = onGameStart;

    // Create the CONNECT message
    var connectMessage = jsonEncode({
      'type': 'CONNECT',
      'payload': {
        'displayName': displayName,
      },
    });

    // Send the CONNECT message after the connection is established
    _channel.sink.add(connectMessage);

    _channel.stream.listen((message) {
      handleMessage(message);
      onMessage(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void startGame() {
    var startMessage = jsonEncode({
      'type': 'START_GAME',
      'payload': {
        'state': "GAME",
      },
    });

    _channel.sink.add(startMessage);
  }

  void sendMessage(String message, {String receiver = 'ALL'}) {
    var jsonMessage = jsonEncode({
      'type': 'TEXT',
      'payload': {'message': message, 'sender': playerId, 'receiver': receiver},
    });
    _channel.sink.add(jsonMessage);

    if (receiver == 'ALL') {
      chatMessages.add('You: $message');
    } else {
      if (!dms.containsKey(receiver)) {
        dms[receiver] = [];
      }
      dms[receiver]!.add('You: $message');
    }
    notifyListeners();
  }

  void close() {
    _channel.sink.close();
  }

  void listPlayers() {
    var checkPlayersMessage = jsonEncode({
      'type': 'CHECK_PLAYERS',
      'payload': {},
    });
    _channel.sink.add(checkPlayersMessage);
  }

  void handleMessage(String message) {
    var jsonMessage = jsonDecode(message);
    var type = MessageType.values.firstWhere(
        (value) => value.toString() == 'MessageType.${jsonMessage['type']}');

    switch (type) {
      case MessageType.CONNECT:
        playerId = jsonMessage['payload'];
        print('Connected with playerId: $playerId');
        listPlayers();
        break;
      case MessageType.CHECK_PLAYERS:
        var playerList = jsonMessage['payload'] as List<dynamic>;
        players = playerList.map((e) => Player(e, e)).toList();
        print('Players: $players');
        notifyListeners();
        break;
      case MessageType.START_GAME:
        onGameStart();
        break;
      case MessageType.END_GAME:
        onGameEnd();
        break;
      case MessageType.CUSTOM:
        // Handle custom messages
        break;
      case MessageType.TEXT:
        var textPayload = jsonMessage['payload'] as Map<String, dynamic>;
        var sender = textPayload['sender'] as String;
        var receiver = textPayload['receiver'] as String;
        var chatMessage = textPayload['message'] as String;

        if (receiver == 'ALL') {
          chatMessages.add('$sender: $chatMessage');
        } else {
          if (!dms.containsKey(sender)) {
            dms[sender] = [];
          }
          dms[sender]!.add('$sender: $chatMessage');
        }
        print('Message from $sender to $receiver: $chatMessage');
        notifyListeners();
        break;
    }
  }
}
