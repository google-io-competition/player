import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:player/style/themed_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../settings/settings.dart';
import '../style/audio/audio_controller.dart';
import '../style/audio/sounds.dart';
import '../style/pallette.dart';
import '../style/themed_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final TextEditingController _lobbyController = TextEditingController();
  List<String> _lobbies = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchLobbies();
  }

  Future<void> _fetchLobbies() async {
    try {
      final response = await http.get(Uri.parse('https://game-master.web.app/lobbies'));
      if (response.statusCode == 200) {
        setState(() {
          _lobbies = List<String>.from(json.decode(response.body));
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load lobbies';
        });
      }
    } on SocketException catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
    }
  }

  void _joinLobby() {
    String lobbyId = _lobbyController.text;
    if (lobbyId.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joining lobby $lobbyId')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Game Master',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ThemedButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/');
              },
              child: const Text('Home'),
            ),
            _gap,
            ThemedButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            _gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleAudioOn(),
                    icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  );
                },
              ),
            ),
            _gap,
            TextField(
              controller: _lobbyController,
              decoration: InputDecoration(
                labelText: 'Enter Lobby ID',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _joinLobby,
                ),
              ),
            ),
            _gap,
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            _gap,
            Expanded(
              child: _lobbies.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _lobbies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_lobbies[index]),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Joining lobby ${_lobbies[index]}')),
                      );
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

  static const _gap = SizedBox(height: 10);
}
