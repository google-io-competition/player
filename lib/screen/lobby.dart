import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:player/style/pallette.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../game/parser/game.dart';
import '../settings/settings.dart';
import '../style/audio/audio_controller.dart';
import '../style/audio/sounds.dart';
import '../style/themed_button.dart';
import '../style/themed_screen.dart';

class CreateLobbyScreen extends StatelessWidget {
  const CreateLobbyScreen({super.key});

  Future<GameParser> _loadGame() async {
    String jsonString = await rootBundle.loadString('assets/imposter.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return GameParser.fromJson(jsonMap);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final settingsController = context.read<SettingsController>();
    final audioController = context.read<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: FutureBuilder<GameParser>(
            future: _loadGame(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text('No data available');
              } else {
                final game = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
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
                    const SizedBox(height: 20),
                    Text(
                      'Game Name: ${game.name}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Author: ${game.author}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Max Players: ${game.maxPlayers}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Min Players: ${game.minPlayers}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'First State Route: ${game.states[0].route}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'First Element Text: ${game.states[0].elements[0].text}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'First Asset Location: ${game.assets[0].location}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              }
            },
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
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}