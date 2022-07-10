import 'package:asallah_fruits/services/dark_theme_prefs.dart';
import 'package:flutter/cupertino.dart';

class DarkThemeProvider with ChangeNotifier
{
  DarkThemePrefs darkThemePrefs = DarkThemePrefs();
  bool darkTheme = false;
  bool get getDarkTheme => darkTheme;

  set setDarkTheme (bool value)
  {
    darkTheme = value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners();
  }
}