import 'package:device_preview/device_preview.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:player/game/game_models.dart';
import 'package:player/widgets/game_screen.dart';

import '../json/local.dart';
import '../palette.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Key devicePreviewKey = UniqueKey();
  final LocalFileStorage _localFileStorage = LocalFileStorage();
  late Future<GameFile> _initialization;
  String? selectedScreen;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeGame();
  }

  Future<GameFile> _initializeGame() async {
    GameFile defaultGame = await loadDefaultGame();
    GameFile game = await _localFileStorage.readGame('game.json') ?? defaultGame;
    return game;
  }

  void restartDevicePreview() {
    setState(() {
      devicePreviewKey = UniqueKey();
    });
  }

  void saveGame(GameFile game) {
    _localFileStorage.writeGame(game.fileName, game);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameFile>(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<GameFile> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          GameFile game = snapshot.data!;
          var screens = game.content.screens;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Palette.primaryColor,
              title: Text(
                'PLAY\'r Editor',
                style: TextStyle(color: Palette.titleColor, fontFamily: 'Itim', fontSize: 20),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => saveGame(game),
                )
              ],
            ),
            backgroundColor: Palette.primaryColor,
            body: Row(
              children: [
                // Left side: Scaffold without AppBar
                Flexible(
                  flex: 65,
                  child: Scaffold(
                    backgroundColor: Palette.primaryColor,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Select a game to edit:',
                              style: TextStyle(fontSize: 18)),
                        ),
                        // Add more widgets here for game selection, etc.
                        // This is just a placeholder for demonstration purposes
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text('Game 1'),
                                onTap: () {
                                  // Handle game selection
                                },
                              ),
                              ListTile(
                                title: Text('Game 2'),
                                onTap: () {
                                  // Handle game selection
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Middle side: List of screens
                Flexible(
                  flex: 10,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: screens.entries.map((entry) {
                      // Create JsonWidgetData from the dynamic data
                      dynamic screenData = entry.value.jsonContent;
                      if (screenData == null && screens.entries.isNotEmpty) {
                        screenData = screens.entries.first.value.jsonContent;
                        print(screenData);
                        print(screens.entries.first.value.jsonContent);
                      }
                      if (screenData == null || screenData.isEmpty) {
                        return ListTile(
                          title: Center(
                              child: Text(entry.key,
                                  style: TextStyle(
                                      fontSize: 15, color: Palette.titleColor))),
                          subtitle: const Text('No data available'),
                          onTap: () {
                            setState(() {
                              selectedScreen = entry.key;
                            });
                          },
                        );
                      }
                      final JsonWidgetData data;
                      try {
                        data = JsonWidgetData.fromDynamic(screenData);
                      } catch (e) {
                        print(e.toString());

                        return ListTile(
                          title: Center(
                              child: Text(entry.key,
                                  style: TextStyle(
                                      fontSize: 15, color: Palette.titleColor))),
                          subtitle: const Text('Error loading preview'),
                          onTap: () {
                            setState(() {
                              selectedScreen = entry.key;
                            });
                          },
                        );
                      }
                      return ListTile(
                        title: Center(
                            child: Text(entry.key,
                                style: TextStyle(
                                    fontSize: 15, color: Palette.titleColor))),
                        subtitle: SizedBox(
                          height: 100, // Adjust height as needed for the preview
                          child: GameScreen(game: game, screen: entry.key)
                        ),
                        onTap: () {
                          setState(() {
                            selectedScreen = entry.key;
                            restartDevicePreview();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                // Right side: JSON-defined UI preview
                Flexible(
                  flex: 25,
                  child: selectedScreen != null
                      ? GameScreen(game: game, screen: selectedScreen!)
                      : GameScreen(game: game, screen: game.content.screens.entries.first.key),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}