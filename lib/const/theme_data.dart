import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dark_theme_provider.dart';
Color? defaultColor = Colors.blue.withOpacity(0.2);

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context)
  {
    final themeState = Provider.of<DarkThemeProvider>(context);

    return ThemeData(
      scaffoldBackgroundColor:
      //0A1931  // white yellow 0xFFFCF8EC
      isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFFFFFFF),
      primaryColor: defaultColor,
      colorScheme: ThemeData().colorScheme.copyWith(
        secondary:
        isDarkTheme ? const Color(0xFF1a1f3c) : defaultColor,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      cardColor:
      isDarkTheme ? const Color(0xFF0a0d2c) : defaultColor,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDarkTheme ? const Color(0xFF1a1f3c) : defaultColor,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
            color:  isDarkTheme ? const Color(0xFFFFFFFF) : const Color(0xFF1a1f3c),
        ),

      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xFF1a1f3c),
        unselectedItemColor: Colors.grey,
        elevation: 0,
        backgroundColor: themeState.getDarkTheme ? Theme.of(context).canvasColor : Colors.white,
      ),

    );
  }
}
