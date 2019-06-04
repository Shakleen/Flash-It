import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/views/my_app.dart';
import 'package:flutter/material.dart';

/// Application starts execution from this main function.
void main() async {
  await EditUserSettings.edit.read();
  runApp(MyApp(key: GlobalKey()));
}
