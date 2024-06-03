import 'package:flutter/material.dart';

class PaletteParser {
  final MaterialColor primaryColor;
  final MaterialColor accentColor;

  PaletteParser({required this.primaryColor, required this.accentColor});

  factory PaletteParser.fromJson(Map<String, dynamic> json) {
    return PaletteParser(
      primaryColor: _parseColor(json['primaryColor']),
      accentColor: _parseColor(json['accentColor']),
    );
  }

  static MaterialColor _parseColor(String colorString) {
    Color color = Color(int.parse(colorString, radix: 16));
    return MaterialColor(color.value, _getSwatch(color));
  }

  static Map<int, Color> _getSwatch(Color color) {
    return {
      50: _tintColor(color, 0.9),
      100: _tintColor(color, 0.8),
      200: _tintColor(color, 0.6),
      300: _tintColor(color, 0.4),
      400: _tintColor(color, 0.2),
      500: color,
      600: _shadeColor(color, 0.1),
      700: _shadeColor(color, 0.2),
      800: _shadeColor(color, 0.3),
      900: _shadeColor(color, 0.4),
    };
  }

  static Color _tintColor(Color color, double factor) {
    return Color.fromRGBO(
      color.red + ((255 - color.red) * factor).round(),
      color.green + ((255 - color.green) * factor).round(),
      color.blue + ((255 - color.blue) * factor).round(),
      1,
    );
  }

  static Color _shadeColor(Color color, double factor) {
    return Color.fromRGBO(
      color.red - (color.red * factor).round(),
      color.green - (color.green * factor).round(),
      color.blue - (color.blue * factor).round(),
      1,
    );
  }
}
