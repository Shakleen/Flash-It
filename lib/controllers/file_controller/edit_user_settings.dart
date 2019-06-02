import 'dart:convert';

import 'package:flash_it/controllers/file_controller/user_files.dart';
import 'package:flash_it/models/entities/user_settings.dart';

class EditUserSettings {
  static final EditUserSettings edit = EditUserSettings._();
  UserSettings settings;

  EditUserSettings._();

  Future<bool> _write() async => UserFiles.files.write(
        json.encode(settings.toMap()),
        await UserFiles.files.settingsFile,
        await UserFiles.files.settingsFilePath,
      );

  Future<bool> read() async {
    final String debug = 'UserFiles - read -'; // TODO DEBUG
    print('$debug beginning read from file'); // TODO DEBUG
    bool status = false;

    try {
      String contents = await UserFiles.files.settingsFileContentString;
      if (contents == null) await _createNew();
      contents = await UserFiles.files.settingsFileContentString;
      print('$debug Settings read are: $contents'); // TODO DEBUG
      settings = UserSettings.fromMap(json.decode(contents));
      status = settings != null;
    } catch (e) {
      print('$debug ${e.runtimeType} $e'); // TODO DEBUG
    }

    print('$debug file read successful: $status'); // TODO DEBUG

    return status;
  }

  Future<bool> _createNew() async {
    final String debug = 'UserFiles - _createNew -'; // TODO DEBUG
    try {
      print('$debug Creating new settings file!'); // TODO DEBUG
      settings = UserSettings.basic();
      return _write();
    } catch (e) {
      print('$debug Exception occured! $e'); // TODO DEBUG
    }

    return false;
  }

  void modifyThemeColor(int selectedThemeColor) {
    settings.appThemeColor = selectedThemeColor;
    _write();
  }

  void modifyLoggedInStatus(bool status) {
    settings.loggedIn = status;
    _write();
  }

  void modifyCardsPerQuiz(int value) {
    settings.cardsPerQuiz = value;
    _write();
  }

  void modifySettingsFileID(String fileID) {
    settings.settingsFileID = fileID;
    _write();
  }

  void modifyTopicFileID(String fileID) {
    settings.topicDBFileID = fileID;
    _write();
  }

  void modifyDeckFileID(String fileID) {
    settings.deckDBFileID = fileID;
    _write();
  }

  void modifyCardFileID(String fileID) {
    settings.cardDBFileID = fileID;
    _write();
  }
}
