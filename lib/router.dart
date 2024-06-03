import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:player/screen/creator.dart';
import 'package:player/screen/lobby.dart';
import 'package:player/screen/menu.dart';
import 'package:player/screen/play.dart';

/// The router describes the game's navigational hierarchy, from the main
/// internals through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
    ),
    GoRoute(
      path: '/host',
      builder: (context, state) => const CreateLobbyScreen(key: Key('create lobby')),
    ),
    GoRoute(
      path: '/join',
      builder: (context, state) => const PlayScreen(key: Key('play game')),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const GameCreationStart(key: Key('create game')),
    ),
  ],
);
