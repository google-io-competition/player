import 'dart:convert';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String jsonString = '''
    {
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {
          "type": "text",
          "args": {
            "text": "List of English words"
          }
        },
        "actions": [
        ]
      }
    },
    "body": {
      "type": "center",
      "args": {
        "child": {
          "type": "circular_progress_indicator",
          "args": {
            "valueColor": "#f00"
          }
        }
      }
    }
  }
}
    ''';

    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final JsonWidgetData data = JsonWidgetData.fromDynamic(jsonData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Game'),
      ),
      body: data.build(context: context),
    );
  }

  simplePrintMessage() {}
}
