import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _themeColorKey = 'theme_color';
  static const _textSizeKey = 'text_size';
  static const _darkModeKey = 'dark_mode';
  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _soundEnabledKey = 'sound_enabled';
  static const _vibrationEnabledKey = 'vibration_enabled';

  late SharedPreferences _prefs;

  // Default values
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
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  void _loadSettings() {
    final colorValue = _prefs.getInt(_themeColorKey);
    if (colorValue != null) {
      _themeColor = Color(colorValue);
    }

    _textSize = _prefs.getDouble(_textSizeKey) ?? AppConstants.mediumTextSize;
    _isDarkMode = _prefs.getBool(_darkModeKey) ?? false;
    _notificationsEnabled = _prefs.getBool(_notificationsEnabledKey) ?? true;
    _soundEnabled = _prefs.getBool(_soundEnabledKey) ?? true;
    _vibrationEnabled = _prefs.getBool(_vibrationEnabledKey) ?? true;

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _prefs.setInt(_themeColorKey, _themeColor.value);
    await _prefs.setDouble(_textSizeKey, _textSize);
    await _prefs.setBool(_darkModeKey, _isDarkMode);
    await _prefs.setBool(_notificationsEnabledKey, _notificationsEnabled);
    await _prefs.setBool(_soundEnabledKey, _soundEnabled);
    await _prefs.setBool(_vibrationEnabledKey, _vibrationEnabled);

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
