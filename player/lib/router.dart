import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:player/screen/menu.dart';
import 'package:player/style/pallette.dart';
import 'package:player/style/themed_transition.dart';
import 'package:provider/provider.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
      ],
    ),
  ],
);
