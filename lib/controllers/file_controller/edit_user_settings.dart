import 'dart:convert';

import 'package:flash_it/controllers/file_controller/user_files.dart';
import 'package:flash_it/models/entities/settings_model.dart';

/// Class for manipulating user settings.
///
/// The class handles the access, edit and updating of user settings. It also
/// handles the writing and reading t0 and from the user settings file. This
/// class has only one instance. It is a singleton class.
///
/// [edit] - Single instance of the class.
/// [settings] - Single instance of the SettingsModel class.
class EditUserSettings {
  static final EditUserSettings edit = EditUserSettings._();
  SettingsModel settings;

  /// Private constructor.
  EditUserSettings._();

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
    settings.topicFileID = fileID;
    _write();
  }

  void modifyDeckFileID(String fileID) {
    settings.deckFileID = fileID;
    _write();
  }

  void modifyCardFileID(String fileID) {
    settings.cardFileID = fileID;
    _write();
  }

  void incrementTopicCount() {
    settings.topics += 1;
    _write();
  }

  void incrementDeckCount() {
    settings.decks += 1;
    _write();
  }

  void incrementCardCount() {
    settings.cards += 1;
    _write();
  }

  /// Method to read content from settings file.
  Future<bool> read() async {
    final String debug = 'UserFiles - read -'; // TODO DEBUG
    print('$debug beginning read from file'); // TODO DEBUG
    bool status = false;

    try {
      String contents = await _getUserSettingsFileContents();
      if (contents == null || contents.isEmpty) await _createNew();
      contents = await _getUserSettingsFileContents();
      print('$debug Settings read are: $contents'); // TODO DEBUG
      settings = SettingsModel.fromMap(json.decode(contents));
      status = settings != null;
    } catch (e) {
      print('$debug ${e.runtimeType} $e'); // TODO DEBUG
    }

    print('$debug file read successful: $status'); // TODO DEBUG

    return status;
  }

  Future<String> _getUserSettingsFileContents() async =>
      await UserFiles.files.settingsFileContentString;

  /// Private method to handle writing of settings file. Called only when data
  /// of settings file has been manipulated through other public classes.
  Future<bool> _write() async {
    print('EditUserSettings - _write - ${json.encode(settings.toMap())}');
    return UserFiles.files.write(
      json.encode(settings.toMap()),
      await UserFiles.files.settingsFile,
      await UserFiles.files.settingsFilePath,
    );
  }

  /// Private method to create a new user settings file. Usually only called when
  /// the application is first installed on a new device.
  Future<bool> _createNew() async {
    final String debug = 'UserFiles - _createNew -'; // TODO DEBUG
    try {
      print('$debug Creating new settings file!'); // TODO DEBUG
      settings = SettingsModel.basic();
      return _write();
    } catch (e) {
      print('$debug Exception occured! $e'); // TODO DEBUG
    }

    return false;
  }
}
