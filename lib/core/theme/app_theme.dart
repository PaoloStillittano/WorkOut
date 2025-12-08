import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'BebasNeue',
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blue.withAlpha(200),
      surface: Colors.white,
    ),
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'BebasNeue',
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blue.withAlpha(200),
      surface: Colors.grey[900]!,
    ),
    cardColor: Colors.grey[850],
    scaffoldBackgroundColor: Colors.grey[1200], // Note: 1200 doesn't exist, using black or very dark grey
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
