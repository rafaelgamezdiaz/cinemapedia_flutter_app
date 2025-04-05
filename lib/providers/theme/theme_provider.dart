import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

bool isDarkMode = false;

@riverpod
class WidgetAppTheme extends _$WidgetAppTheme {
  @override
  bool build() => isDarkMode;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    state = isDarkMode;
  }
}

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  AppTheme build() => AppTheme(); // state va a ser una instancia de Apptheme

  void toggleDarkMode() {
    print('toggleDarkMode ${state.brightness}');
    state = state.copyWith(
      brightness:
          state.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
    );
  }
}
