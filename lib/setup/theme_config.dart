import 'package:flutter/material.dart';

class ThemeConfig {
  // App Colors
  static Color lightPrimary = Color(0xfff3f4f9);
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Color(0xff597ef7);
  static Color darkAccent = Color(0xff597ef7);
  static Color lightBG = Color(0xfff3f4f9);
  static Color darkBG = Color(0xff121212);
  static Color backgroundSmokeWhite = Color(0xffB0C6D0).withOpacity(0.1);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    scaffoldBackgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    scaffoldBackgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      textTheme: TextTheme(
        headline6: TextStyle(
            color: lightBG, fontSize: 20.0, fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
