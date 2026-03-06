import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  static const String _themeKey = 'app_theme_mode';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString(_themeKey);

    switch (savedValue) {
      case 'dark':
        emit(ThemeMode.dark);
        break;
      case 'light':
        emit(ThemeMode.light);
        break;
      default:
        emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  bool get isDark => state == ThemeMode.dark;
}