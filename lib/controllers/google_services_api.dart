import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
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
  /// Topic.db, Deck.db, Card.db and Settings.json
  Future<void> sync() async {
//    // Sync topics
//    await _sync(
//      EditUserSettings.edit.settings.topicDBFileID,
//      UserFiles.files.topicFileName,
//      UserFiles.files.topicFileDescription,
//      await UserFiles.files.topicFile,
//      EditUserSettings.edit.modifyTopicFileID,
//      await UserFiles.files.topicFilePath,
//    );
//
//    // Sync Decks
//    await _sync(
//      EditUserSettings.edit.settings.deckDBFileID,
//      UserFiles.files.deckFileName,
//      UserFiles.files.deckFileDescription,
//      await UserFiles.files.deckFile,
//      EditUserSettings.edit.modifyDeckFileID,
//      await UserFiles.files.deckFilePath,
//    );
//
//    // Sync cards
//    await _sync(
//      EditUserSettings.edit.settings.cardDBFileID,
//      UserFiles.files.cardFileName,
//      UserFiles.files.cardFileDescription,
//      await UserFiles.files.cardFile,
//      EditUserSettings.edit.modifyCardFileID,
//      await UserFiles.files.cardFilePath,
//    );
//
//    // Sync settings
//    await _sync(
//      EditUserSettings.edit.settings.settingsFileID,
//      UserFiles.files.settingsFileName,
//      UserFiles.files.settingsFileDescription,
//      await UserFiles.files.settingsFile,
//      EditUserSettings.edit.modifySettingsFileID,
//      await UserFiles.files.settingsFilePath,
//    );
  }

  /// Helper method for syncing file content.
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
  Future<void> _sync(
    String fileID,
    String metaName,
    String metaDescription,
    io.File file,
    Function(String fileID) modify,
    String filePath,
  ) async {
    final String debug = 'GoogleServicesAPI - _sync';
    print('$debug Started syncing $metaName!'); // TODO DEBUG

    // Create meta data
    final File meta = File();
    meta
      ..name = metaName
      ..description = metaDescription;

    // File id is known in local settings file.
    if (fileID != null) {
      print('$debug fileID known. Updating file!'); // TODO DEBUG
      // We will upload the changes to drive.
      await _driveApi.files.update(meta, fileID,
          uploadMedia: Media(file.openRead(), await file.length()));
      return;
    }

    // File id isn't in local settings file. Check if file is in drive.
    final String id = await _checkDriveForFileID(metaName, metaDescription);

    // File is in drive. Download and create local copy.
    if (id != null) {
      print('$debug file in drive. Making local copy!'); // TODO DEBUG
      UserFiles.files
          .write(await _downloadFileContentFromDrive(id), file, filePath);
      return;
    }

    // File isn't in drive. Create and upload new instance.
    print('$debug fileID not known. Uploading for 1st time!'); // TODO DEBUG
    _createNew(meta, file);

    print('$debug Finished syncing $metaName!'); // TODO DEBUG
  }

  /// Helper method for getting the fileID of the file having [name] and
  /// [description] as meta data.
  ///
  /// Returns the right file id or null.
  Future<String> _checkDriveForFileID(String name, String description) async {
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

  /// Helper method for downloading the contents of the file having the
  /// [fileID].
  ///
  /// Returns the contents as a string.
  Future<String> _downloadFileContentFromDrive(String fileID) async {
    final String debug =
        'GoogleServicesAPI - _downloadFileContentFromDrive'; // TODO DEBUG
    final Media download = await _driveApi.files.get(
      fileID,
      downloadOptions: DownloadOptions(),
    );

    final StringBuffer content = StringBuffer();
    download.stream.transform(Utf8Decoder()).transform(LineSplitter()).listen(
          (String line) => content.write(line),
          onDone: () => print(content.toString()),
          onError: (e) {
            print('$debug Error occured! $e');
            download.stream.listen((List<int> l) => content.write(l));
          }, // TODO DEBUG
        );
    return content.toString();
  }

  /// Helper method for creating a new file and uploading it to google drive.
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
