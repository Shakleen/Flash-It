import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/presentation/themes.dart';
import 'package:flash_it/views/about_page.dart';
import 'package:flash_it/views/home_page.dart';
import 'package:flash_it/views/log_in_page.dart';
import 'package:flash_it/views/settings_page.dart';
import 'package:flutter/material.dart';

/// Class that defines the theme and navigation routes of the entire application.
class MyApp extends StatefulWidget {
  final Widget child;

  MyApp({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
    key: Key("_MyAppState"),
    title: "Flash It!",
    home: LogInPage(),
    theme: themes[EditUserSettings.edit.settings.appThemeColor],
    routes: {
      'home': (BuildContext context) => HomePage(),
      'settings': (BuildContext context) =>
          SettingsPage(
            changeTheme: _changeTheme,
          ),
      'about': (BuildContext context) => AboutPage(),
    },
  );

  void _changeTheme() {
    setState(() {});
  }
}
