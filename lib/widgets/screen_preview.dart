import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:player/game/game_models.dart';

import '../json/local.dart';

class ScreenPreview extends StatelessWidget {
  final Screen screen;

  ScreenPreview({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    // Fetch the JSON data for the current screen
    Screen screenData = screen;

    // Check if screenData is not null and valid
    if (screenData.jsonContent.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No data available for the current screen')),
      );
    }

    // Create JsonWidgetData from the dynamic data
    JsonWidgetData data = JsonWidgetData.fromDynamic(screenData.jsonContent);
    Widget widget = data.build(context: context);

    return Container(
      child: widget,
    );
  }
}