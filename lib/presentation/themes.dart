import 'package:flutter/material.dart';

final List<ThemeData> themes = [
  // Red theme
  ThemeData(
    // Primary colors
    primaryColor: Colors.red,
    primaryColorLight: Colors.red[100],
    primaryColorDark: Colors.red[800],

    // Secondary color
    accentColor: Colors.redAccent,

    // Brightness
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    errorColor: Colors.purple,

    highlightColor: Colors.white,
    backgroundColor: Colors.white,
    fontFamily: 'Roboto',

    // Text theme
    textTheme: TextTheme(
      title: TextStyle(color: Colors.red),
      headline: TextStyle(color: Colors.black),
      subtitle: TextStyle(color: Colors.black),
      subhead: TextStyle(color: Colors.black),
      body1: TextStyle(color: Colors.black),
      body2: TextStyle(color: Colors.white),
      display1: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Colors.white70, size: 26),
    secondaryHeaderColor: Colors.black54,
    buttonColor: Colors.red,
    bottomAppBarColor: Colors.red,
  ),

  // Green theme
  ThemeData(
    // Primary colors
    primaryColor: Colors.green,
    primaryColorLight: Colors.green[100],
    primaryColorDark: Colors.green[800],

    // Secondary color
    accentColor: Colors.greenAccent,

    // Brightness
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    errorColor: Colors.red,

    highlightColor: Colors.white,
    backgroundColor: Colors.white,
    fontFamily: 'Roboto',

    // Text theme
    textTheme: TextTheme(
      title: TextStyle(color: Colors.green),
      headline: TextStyle(color: Colors.black),
      subtitle: TextStyle(color: Colors.black),
      subhead: TextStyle(color: Colors.black),
      body1: TextStyle(color: Colors.black),
      body2: TextStyle(color: Colors.white),
      display1: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Colors.white70, size: 26),
    secondaryHeaderColor: Colors.black54,
    buttonColor: Colors.green,
    bottomAppBarColor: Colors.green,
  ),

  // Blue theme
  ThemeData(
    // Primary colors
    primaryColor: Colors.blue,
    primaryColorLight: Colors.blue[75],
    primaryColorDark: Colors.blue[800],

    // Secondary color
    accentColor: Colors.blueAccent,

    // Brightness
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    errorColor: Colors.red,

    highlightColor: Colors.white,
    backgroundColor: Colors.white,
    fontFamily: 'Roboto',

    // Text theme
    textTheme: TextTheme(
      title: TextStyle(color: Colors.blue),
      headline: TextStyle(color: Colors.black),
      subtitle: TextStyle(color: Colors.black),
      subhead: TextStyle(color: Colors.black),
      body1: TextStyle(color: Colors.black),
      body2: TextStyle(color: Colors.white),
      display1: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Colors.white70, size: 26),
    secondaryHeaderColor: Colors.black54,
    buttonColor: Colors.blue,
    bottomAppBarColor: Colors.blue,
  ),

  // Purple theme
  ThemeData(
    // Primary colors
    primaryColor: Colors.purple,
    primaryColorLight: Colors.purple[100],
    primaryColorDark: Colors.purple[800],

    // Secondary color
    accentColor: Colors.purpleAccent,

    // Brightness
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    errorColor: Colors.red,

    highlightColor: Colors.white,
    backgroundColor: Colors.white,
    fontFamily: 'Roboto',

    // Text theme
    textTheme: TextTheme(
      title: TextStyle(color: Colors.purple),
      headline: TextStyle(color: Colors.black),
      subtitle: TextStyle(color: Colors.black),
      subhead: TextStyle(color: Colors.black),
      body1: TextStyle(color: Colors.black),
      body2: TextStyle(color: Colors.white),
      display1: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Colors.white70, size: 26),
    secondaryHeaderColor: Colors.black54,
    buttonColor: Colors.purple,
    bottomAppBarColor: Colors.purple,
  ),

  // Purple theme
  ThemeData(
    // Primary colors
    primaryColor: Colors.pink,
    primaryColorLight: Colors.pink[100],
    primaryColorDark: Colors.pink[800],

    // Secondary color
    accentColor: Colors.pinkAccent,

    // Brightness
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    errorColor: Colors.red,

    highlightColor: Colors.white,
    backgroundColor: Colors.white,
    fontFamily: 'Roboto',

    // Text theme
    textTheme: TextTheme(
      title: TextStyle(color: Colors.pink),
      headline: TextStyle(color: Colors.black),
      subtitle: TextStyle(color: Colors.black),
      subhead: TextStyle(color: Colors.black),
      body1: TextStyle(color: Colors.black),
      body2: TextStyle(color: Colors.white),
      display1: TextStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(color: Colors.white70, size: 26),
    secondaryHeaderColor: Colors.black54,
    buttonColor: Colors.pink,
    bottomAppBarColor: Colors.pink,
  ),
];
