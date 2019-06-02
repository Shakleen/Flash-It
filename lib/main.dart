import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/views/my_app.dart';
import 'package:flutter/material.dart';

/// Application starts execution from this main function.
void main() async {
  await EditUserSettings.edit.read();
  runApp(MyApp(key: GlobalKey()));
}
// SHA1 : C0:E1:07:6A:76:88:76:50:8F:4F:12:B9:00:4A:A3:F6:2A:71:29:9A
