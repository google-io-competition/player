import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:device_preview/device_preview.dart';

import '../game/game_models.dart';
import '../json/local.dart';

class ScreenTest extends StatelessWidget {
  LocalFileStorage _localFileStorage = LocalFileStorage();
  ScreenTest({super.key});

  Future<JsonWidgetData> loadJsonWidgetData() async {
    // Load the default game file if no game file exists in local storage
    final GameFile defaultGame = await loadDefaultGame();
    final GameFile gameFile = await _localFileStorage.readGame('game4.json') ?? defaultGame;

    // Parse the JSON content to create JsonWidgetData
    final Map<String, dynamic> jsonMap = gameFile.content.screens.entries.first.value.jsonContent;

    return JsonWidgetData.fromDynamic(jsonMap);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JsonWidgetData>(
      future: loadJsonWidgetData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the JSON data to load, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If there is an error loading the JSON data, show an error message
          return Center(child: Text('Error loading JSON: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // If no data is available, show an appropriate message
          return const Center(child: Text('No data available'));
        }

        // Build the widget from the loaded JsonWidgetData
        final JsonWidgetData data = snapshot.data!;
        final Widget widget = data.build(context: context);

        return DeviceFrame(
          device: Devices.ios.iPhone13ProMax,
          screen: widget,
        );
      },
    );
  }
}