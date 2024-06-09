import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:player/screen/lobby.dart';
import 'package:player/screen/menu.dart';
import 'package:player/screen/play.dart';
import 'package:player/settings/settings.dart';
import 'package:player/style/audio/audio_controller.dart';
import 'package:player/style/pallette.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'lifecycle/app_lifecycle.dart';
import 'multiplayer/api_service.dart';
import 'multiplayer/firestore_controller.dart';
import 'multiplayer/websocket_service.dart';

// Function to load the JSON file from assets
Future<String> loadJsonAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() async {
  // Basic logging setup.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  Logger.root.onRecord.listen((record) {
    dev.log('${record.level.name}: ${record.time}: ${record.message}',
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Provider.value(
      value: FirebaseFirestore.instance,
      child: const Player(),
    ),
  );
}

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
          providers: [
            Provider(create: (context) => SettingsController()),
            Provider(create: (context) => Palette()),
            Provider(create: (context) => AudioController()),
            Provider(create: (context) => ApiService()),
            Provider(create: (context) => WebSocketService()),
          ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'PLAY\'r',
            routerConfig: _router,
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                surface: palette.backgroundMain,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: palette.ink),
              ),
              useMaterial3: true,
            ).copyWith(
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          );
        })
      )
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const MainMenuScreen(),
    ),
    GoRoute(
      path: '/join',
      builder: (context, state) => const PlayScreen(),
    ),
    GoRoute(
      path: '/lobby/:id',
      builder: (context, state) {
        final lobbyId = state.pathParameters['id']!;
        final userId = state.extra as String;  // Retrieve the userId from the extra parameter
        return LobbyScreen(
          lobbyId: lobbyId,
          userId: userId,
          firestoreController: FirestoreController(
            instance: FirebaseFirestore.instance,
            boardState: BoardState(element: BoardElement(text: '', duration: 0)),
          ),
          webSocketService: context.read<WebSocketService>(),
        );
      },
    )
  ],
);