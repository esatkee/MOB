import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../functions/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SettingsProvider extends ChangeNotifier {
  static const _table = 'settings';
  static const _rowId = 1;

  Color _themeColor = AppConstants.primaryColor;
  double _textSize = AppConstants.mediumTextSize;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  Color get themeColor => _themeColor;
  double get textSize => _textSize;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  Future<void> init() async {
    final db = await DatabaseHelper().database;
    final settingsList = await db.query(_table, where: 'id = ?', whereArgs: [_rowId]);

    if (settingsList.isNotEmpty) {
      final settings = settingsList.first;
      _themeColor = Color(settings['themeColor'] as int);
      _textSize = settings['textSize'] as double;
      _isDarkMode = (settings['darkMode'] as int) == 1;
      _notificationsEnabled = (settings['notificationsEnabled'] as int) == 1;
      _soundEnabled = (settings['soundEnabled'] as int) == 1;
      _vibrationEnabled = (settings['vibrationEnabled'] as int) == 1;
    }

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final db = await DatabaseHelper().database;
    await db.update(
      _table,
      {
        'themeColor': _themeColor.value,
        'textSize': _textSize,
        'darkMode': _isDarkMode ? 1 : 0,
        'notificationsEnabled': _notificationsEnabled ? 1 : 0,
        'soundEnabled': _soundEnabled ? 1 : 0,
        'vibrationEnabled': _vibrationEnabled ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [_rowId],
    );
    notifyListeners();
  }

  void updateThemeColor(Color color) {
    _themeColor = color;
    _saveSettings();
  }

  void updateTextSize(double size) {
    _textSize = size;
    _saveSettings();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _saveSettings();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _saveSettings();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    _saveSettings();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    _saveSettings();
  }
}