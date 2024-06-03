import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:player/style/themed_button.dart';
import 'package:provider/provider.dart';

import '../settings/settings.dart';
import '../style/audio/audio_controller.dart';
import '../style/audio/sounds.dart';
import '../style/pallette.dart';
import '../style/themed_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

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
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/host');
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
