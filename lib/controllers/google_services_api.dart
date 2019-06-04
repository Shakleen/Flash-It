import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flash_it/controllers/file_controller/card_file.dart';
import 'package:flash_it/controllers/file_controller/deck_file.dart';
import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/controllers/file_controller/topic_file.dart';
import 'package:flash_it/controllers/file_controller/user_files.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

/// Class for handling the communication with Google Services.
///
/// The class handles sign-in through google account, authentication and
/// communication with Google Drive for accessing and backing up application
/// files.
///
/// [gService] - Singleton of this class. Only instance of this class.
/// [_googleSignIn] - Variable used to sign in using google account. Provides
/// scope for access.
/// [_account] - Account used to sign in with. Holds account name, email and
/// account picture.
/// [_driveApi] - Object used to access the features and functions of the drive
/// API.
/// [_httpClient] - Object used to send and receive http requests to google
/// services.
class GoogleServicesAPI {
  static final GoogleServicesAPI gService = GoogleServicesAPI._();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'https://www.googleapis.com/auth/drive.file'],
  );
  GoogleSignInAccount _account;
  DriveApi _driveApi;
  GoogleHttpClient _httpClient;

  /// Private constructor.
  GoogleServicesAPI._();

  String get userName => _account?.displayName;

  String get email => _account?.email;

  String get photoURL => _account?.photoUrl;

  /// Method for signing in using google account.
  ///
  /// The application needs access to user's Google Drive to store application
  /// information as a cloud backup. This method handles the sign-in and
  /// initialization of the [_driveApi] and [_httpClient] objects.
  Future<bool> signIn() async {
    _account = await _googleSignIn.signIn();
    EditUserSettings.edit.modifyLoggedInStatus(_account != null);
    _httpClient = GoogleHttpClient(await _googleSignIn.currentUser.authHeaders);
    _driveApi = DriveApi(_httpClient);
    return _account != null;
  }

  /// Method for syncing local and cloud data.
  ///
  /// The application stores data locally for easy access and in the cloud for
  /// safe keeping. This method handles the syncing of 4 files which are mainly
  /// Topic.json, Deck.json, Card.json and Settings.json
  Future<void> syncData() async {
    await _handleSettingsSync();
    await _handleTopicSync();
    await _handleDeckSync();
    await _handleCardSync();
  }

  /// Private method to sync settings.json file.
  Future<void> _handleSettingsSync() async {
    await _syncOperation(
      EditUserSettings.edit.settings.settingsFileID,
      UserFiles.files.settingsFileName,
      await UserFiles.files.settingsFile,
      EditUserSettings.edit.modifySettingsFileID,
      await UserFiles.files.settingsFilePath,
    );
  }

  /// Private method to sync card.json file.
  ///
  /// If necessary a new database is created from the synced information
  Future<void> _handleCardSync() async {
    final bool createCardDatabase = await _syncOperation(
      EditUserSettings.edit.settings.cardFileID,
      UserFiles.files.cardJsonName,
      await UserFiles.files.cardJson,
      EditUserSettings.edit.modifyCardFileID,
      await UserFiles.files.cardJsonPath,
    );

    print(
        'GoogleServices - _handleCardSync - CreateCardDatabase: $createCardDatabase');
    if (createCardDatabase) CardFile.cardFile.createDatabase();
  }

  /// Private method to sync deck.json file.
  ///
  /// If necessary a new database is created from the synced information
  Future<void> _handleDeckSync() async {
    final bool createDeckDatabase = await _syncOperation(
      EditUserSettings.edit.settings.deckFileID,
      UserFiles.files.deckJsonName,
      await UserFiles.files.deckJson,
      EditUserSettings.edit.modifyDeckFileID,
      await UserFiles.files.deckJsonPath,
    );

    print(
        'GoogleServices - _handleCardSync - createDeckDatabase: $createDeckDatabase');
    if (createDeckDatabase) DeckFile.deckFile.createDatabase();
  }

  /// Private method to sync topic.json file.
  ///
  /// If necessary a new database is created from the synced information
  Future<void> _handleTopicSync() async {
    final bool createTopicDatabase = await _syncOperation(
      EditUserSettings.edit.settings.topicFileID,
      UserFiles.files.topicJsonName,
      await UserFiles.files.topicJson,
      EditUserSettings.edit.modifyTopicFileID,
      await UserFiles.files.topicJsonPath,
    );

    print(
        'GoogleServices - _handleCardSync - createTopicDatabase: $createTopicDatabase');
    if (createTopicDatabase) TopicFile.topicFile.createDatabase();
  }

  /// Private method for syncing file content.
  ///
  /// The parameters this method takes are used in the syncing process.
  /// [fileID] - The file id assigned in google drive for the particular file.
  /// [metaName] - The name of the file
  /// [metaDescription] - The description of the file
  /// [file] - The file holding the content to be uploaded or written to.
  /// [modify] - A function that's used to modify the contents of [file].
  /// [filePath] - The relative path to [file]
  ///
  /// This method follows this process when syncing files:
  /// 1. Check if [fileID] is known locally.
  /// 2. If [fileID] is known then we will use the [fileID] to update the
  /// contents of the file pointed to by this [fileID]. The contents are of
  /// [file].
  /// 3. If [fileID] is not known locally then check if drive has the file.
  /// 4. If Drive has the file then [_checkDriveForFileID] is called to get the
  /// proper [fileID]. Then the contents of the file are retrieved using
  /// [_downloadFileContentFromDrive].
  /// 5. However if even the drive doesn't have the file then a new one is
  /// created and then uploaded to the drive. The new [fileID] is stored
  /// locally.
  ///
  /// The return value for the function signifies if the local database needs
  /// to be updated. True if update is necessary, false otherwise.
  Future<bool> _syncOperation(
    String fileID,
    String metaName,
    io.File file,
    Function(String fileID) modify,
    String filePath,
  ) async {
    final String debug = 'GoogleServicesAPI - _sync'; //TODO DEBUG
    print('$debug Started syncing $metaName!'); // TODO DEBUG

    // Create meta data
    final File meta = File();
    meta.name = metaName;

    // File id is known in local settings file.
    if (fileID != null) {
      print('$debug fileID known. Updating file!'); // TODO DEBUG
      // We will upload the changes to drive.
      await _driveApi.files.update(
        meta,
        fileID,
        uploadMedia: Media(file.openRead(), await file.length()),
      );
      return false;
    }

    // File id isn't in local settings file. Check if file is in drive.
    String id = await _checkDriveForFileID(metaName);

    // File is in drive. Download and create local copy.
    if (id != null) {
      print('$debug file in drive. Making local copy!'); // TODO DEBUG
      await _downloadFileContentFromDrive(id, file, filePath);
      modify(id);
      return true;
    }

    // File isn't in drive. Create and upload new instance.
    print('$debug fileID not known. Uploading for 1st time!'); // TODO DEBUG
    id = await _createNew(meta, file);
    modify(id);

    print('$debug Finished syncing $metaName!'); // TODO DEBUG
    return false;
  }

  /// Private method for getting the fileID of the file having [name] and
  /// [description] as meta data.
  ///
  /// Returns the right file id or null.
  Future<String> _checkDriveForFileID(String name) async {
    FileList result;
    final String debug =
        'GoogleServicesAPI - _checkDriveForFileID'; // TODO DEBUG

    while (true) {
      result = await _driveApi.files.list(
        pageSize: 1000,
        pageToken: result?.nextPageToken,
        q: "name='$name'",
      );

      if (result.files.isEmpty) break;

      print('$debug Result size is ${result.files.length}'); // TODO DEBUG
      for (File file in result.files)
        if (file.name == name) {
          print('$debug ID gotten is ${file.id}'); // TODO DEBUG
          return file.id;
        }
    }

    return null;
  }

  /// Private method for downloading the contents of the file having the
  /// [fileID].
  ///
  /// Returns the contents as a string.
  Future<void> _downloadFileContentFromDrive(String fileID,
      io.File file,
      String filePath,) async {
    final String debug =
        'GoogleServicesAPI - _downloadFileContentFromDrive'; // TODO DEBUG
    final Media download = await _driveApi.files.get(
      fileID,
      downloadOptions: DownloadOptions.FullMedia,
    );

    final StringBuffer content = StringBuffer();
    download.stream.transform(Utf8Decoder()).transform(LineSplitter()).listen(
          (String line) => content.write(line),
      onDone: () async {
        final String contentString = content.toString();
        print('Content is $contentString}');
        await UserFiles.files.write(
          contentString,
          file,
          filePath,
        );
      },
      onError: (e) {
        print('$debug Error occured! $e');
        download.stream.listen((List<int> l) => content.write(l));
      }, // TODO DEBUG
    );
  }

  /// Private method for creating a new file and uploading it to google drive.
  ///
  /// THe file will have [meta] as meta data and [file] as contents.
  Future<String> _createNew(File meta, io.File file) async {
    final File uploaded = await _driveApi.files.create(
      meta,
      uploadMedia: Media(file.openRead(), await file.length()),
    );
    return uploaded?.id;
  }
}

/// Class for google http client.
///
/// Implements functions necessary for sending and receiving the http requests.
class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
