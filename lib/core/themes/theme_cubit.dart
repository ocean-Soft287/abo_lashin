import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../local/app_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final AppPreferences _preferences;

  ThemeCubit(this._preferences) : super(_preferences.themeMode);

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    await _preferences.saveThemeMode(mode);
  }
}
