import 'package:flutter/material.dart';

class AppTheme {
  final Brightness brightness;

  AppTheme({this.brightness = Brightness.dark});

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: const Color(0xff2862F5),
    brightness: brightness,
  );

  AppTheme copyWith({Brightness? brightness}) {
    return AppTheme(brightness: brightness ?? this.brightness);
  }
}
