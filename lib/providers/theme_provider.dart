import 'package:flutter/material.dart';
import 'package:streamscape/services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final String _themeKey = 'theme_mode';
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await _storageService.get(_themeKey);
    _isDarkMode = savedTheme == 'dark';
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.set(_themeKey, _isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}
