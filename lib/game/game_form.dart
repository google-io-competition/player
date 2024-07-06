import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class FormFieldData {
  final String label;
  final TextEditingController controller;

  FormFieldData({required this.label, required this.controller});
}

class FormModel with ChangeNotifier {
  Map<String, FormFieldData> _fields = {
    'name': FormFieldData(label: 'Name', controller: TextEditingController()),
    'description': FormFieldData(label: 'Description', controller: TextEditingController()),
    'icon': FormFieldData(label: 'Icon URL', controller: TextEditingController()),
    'type': FormFieldData(label: 'Type', controller: TextEditingController()),
    'minPlayers': FormFieldData(label: 'Min Players', controller: TextEditingController()),
    'maxPlayers': FormFieldData(label: 'Max Players', controller: TextEditingController()),
    'author': FormFieldData(label: 'Author', controller: TextEditingController()),
  };

  Map<String, FormFieldData> get fields => _fields;

  void addField(String key, String label) {
    _fields[key] = FormFieldData(label: label, controller: TextEditingController());
    notifyListeners();
  }

  void removeField(String key) {
    _fields.remove(key);
    notifyListeners();
  }

  void updateField(String key, String value) {
    if (_fields.containsKey(key)) {
      _fields[key]!.controller.text = value;
      notifyListeners();
    }
  }

  String getField(String key) {
    return _fields[key]?.controller.text ?? '';
  }
}