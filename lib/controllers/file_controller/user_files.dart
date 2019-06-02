import 'dart:io';

import 'package:path_provider/path_provider.dart';

class UserFiles {
  static final UserFiles files = UserFiles._();
  final String topicFileName = "Topics";
  final String topicJsonName = "FlashItTopics.json";
  final String deckFileName = "Decks";
  final String deckJsonName = "FlashItDecks.json";
  final String cardFileName = "Cards";
  final String cardJsonName = "FlashItCards.json";
  final String settingsFileName = "FlashItSettings.json";

  UserFiles._();

  Future<String> get topicFilePath async => _getPath(topicFileName);

  Future<String> get deckFilePath async => _getPath(deckFileName);

  Future<String> get cardFilePath async => _getPath(cardFileName);

  Future<String> get topicJsonPath async => _getPath(topicJsonName);

  Future<String> get deckJsonPath async => _getPath(deckJsonName);

  Future<String> get cardJsonPath async => _getPath(cardJsonName);

  Future<String> get settingsFilePath async => _getPath(settingsFileName);

  Future<File> get topicFile async => _getFile(topicFileName);

  Future<File> get deckFile async => _getFile(deckFileName);

  Future<File> get cardFile async => _getFile(cardFileName);

  Future<File> get topicJson async => _getFile(topicJsonName);

  Future<File> get deckJson async => _getFile(deckJsonName);

  Future<File> get cardJson async => _getFile(cardJsonName);

  Future<File> get settingsFile async => _getFile(settingsFileName);

  Future<String> get topicFileContentString async =>
      _getFileContentString(topicFileName);

  Future<String> get deckFileContentString async =>
      _getFileContentString(deckFileName);

  Future<String> get cardFileContentString async =>
      _getFileContentString(cardFileName);

  Future<String> get topicJsonContentString async =>
      _getFileContentString(topicJsonName);

  Future<String> get deckJsonContentString async =>
      _getFileContentString(deckJsonName);

  Future<String> get cardJsonContentString async =>
      _getFileContentString(cardJsonName);

  Future<String> get settingsFileContentString async =>
      _getFileContentString(settingsFileName);

  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> _getPath(String fileName) async {
    final String path = await _localPath;
    return '$path/$fileName';
  }

  Future<File> _getFile(String fileName) async {
    final String path = await _localPath;
    final File returnFile = File('$path/$fileName');
    if (await returnFile.exists()) return returnFile;
    return null;
  }

  Future<String> _getFileContentString(String fileName) async {
    final File file = await _getFile(fileName);
    if (file != null) return file.readAsString();
    return null;
  }

  Future<bool> write(String content, File file, String filePath) async =>
      await File(filePath).writeAsString(content) != null;
}
