import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import '../multiplayer/firestore_controller.dart';
import '../settings/settings.dart';
import '../style/audio/audio_controller.dart';
import '../style/audio/sounds.dart';
import '../style/pallette.dart';
import '../style/themed_button.dart';
import '../style/themed_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();
    final boardState = BoardState(element: BoardElement(text: '', duration: 0));  // Initialize with default values
    final firestoreController = FirestoreController(instance: FirebaseFirestore.instance, boardState: boardState);
    final Logger log = Logger('MainMenuScreen');

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: Image.asset(
              'icon/logo.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ThemedButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/join');
              },
              child: const Text('Join'),
            ),
            _gap,
            ThemedButton(
              onPressed: () async {
                audioController.playSfx(SfxType.buttonTap);
                try {
                  log.info('Attempting to create a lobby');
                  final lobbyRef = await firestoreController.createLobby();
                  log.info('Navigating to lobby with ID: ${lobbyRef.id}');

                  final userName = settingsController.displayName.value;
                  GoRouter.of(context).go('/lobby/${lobbyRef.id}', extra: userName);
                } catch (e) {
                  log.severe('Failed to create lobby: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create lobby: $e')),
                  );
                }
              },
              child: const Text('Host'),
            ),
            _gap,
            ThemedButton(
              onPressed: () => GoRouter.of(context).push('/create'),
              child: const Text('Create'),
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
