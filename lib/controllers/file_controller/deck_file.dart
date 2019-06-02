import 'dart:convert';

import 'package:flash_it/controllers/file_controller/user_files.dart';
import 'package:flash_it/models/entities/deck_model.dart';

/// Class for handling the reading, writing and manipulation of the deck.json
/// file.
///
/// The class rewrites the deck.json file upon new deck addition, deletion and
/// information update.
///
/// [decks] - A list of [DeckModel] type objects that temporarily stores the
/// decks in between reading and writing.
///
/// [deckFile] - Singleton for this class.
class DeckFile {
  static final DeckFile deckFile = DeckFile._();
  final List<DeckModel> decks = [];

  /// Private constructor.
  DeckFile._();

  /// Add a new deck to the file deck.json
  void add(Map<String, dynamic> input) => _process(input, _addTodeck);

  /// Remove a deck from the file deck.json
  void remove(Map<String, dynamic> input) => _process(input, _deleteFromdecks);

  /// Update value of a deck in file deck.json
  void update(Map<String, dynamic> value, Map<String, dynamic> newValue) =>
      _process(
        value,
        _deleteFromdecks,
        op2: _addTodeck,
        newValue: newValue,
      );

  /// Helper method for reading, decoding and adding contents of the file
  /// deck.json to the list [decks].
  Future<void> _read() async {
    final String debug = "DeckFile - _read"; // TODO DEBUG
    final String content = await UserFiles.files.deckJsonContentString;
    print(
        "$debug content of type ${content.runtimeType} is $content"); // TODO DEBUG
    decks.clear();
    if (content != null) if (content.isNotEmpty) {
      List<dynamic> read = json.decode(content);
      decks.addAll(
        read.map((dynamic item) => DeckModel.fromMap(item)).toList(),
      );
    }
  }

  /// Helper method for encoding and writing the contents of [decks] into
  /// the file decks.json
  Future<void> _write() async {
    final String debug = "DeckFile - _write"; // TODO DEBUG
    final List<Map<String, dynamic>> jsonFormat = [];
    for (DeckModel deck in decks) jsonFormat.add(deck.toMap());
    final String content = json.encode(jsonFormat);
    print(
        '$debug content of type ${content.runtimeType} is $content'); // TODO DEBUG
    UserFiles.files.write(
      content,
      await UserFiles.files.deckJson,
      await UserFiles.files.deckJsonPath,
    );
  }

  /// Helper method to manipulate the contents of the file deck.json
  ///
  /// This method first reads from the file deck.json to get all its contents.
  /// Then it performs the [op1] with [value] as an argument, which can be add
  /// or remove. Then depending on the value of the [newValue] variable it may
  /// run [op2] with [newValue] passed as an argument.
  void _process(
    Map<String, dynamic> value,
    Function(DeckModel value) op1, {
    Function(DeckModel value) op2,
    Map<String, dynamic> newValue,
  }) async {
    value['id'] = null;
    await _read();
    print("Value received is $value");
    for (DeckModel deck in decks) print('${deck.toMap()}');
    print(op1(DeckModel.fromMap(value)));
    if (newValue != null) {
      newValue['id'] = null;
      op2(DeckModel.fromMap(newValue));
    }
    _write();
  }

  /// Helper method to check and delete appropriate deck from the list [decks].
  ///
  /// The method compares the set dates to identify the appropriate deck. As
  /// the set time is accurate upto the microsecond it is impossible for two
  /// decks to have the same creation time. If a match is found then [deck] is
  /// deleted from [decks].
  bool _deleteFromdecks(DeckModel deck) {
    DateTime createdDate = deck.creationDate;
    for (int i = 0; i < decks.length; ++i)
      if (decks[i].creationDate == createdDate) {
        decks.removeAt(i);
        return true;
      }
    return false;
  }

  /// Helper method to check and add deck to the list [decks].
  ///
  /// The method compares the set dates to identify appropriate deck. As
  /// the set time is accurate upto the microsecond it is impossible for two
  /// decks to have the same creation time. If a deck with the same set date
  /// exists in the list then [deck] isn't added.
  bool _addTodeck(DeckModel deck) {
    DateTime createdDate = deck.creationDate;
    bool found = false;

    for (int i = 0; i < decks.length; ++i)
      if (decks[i].creationDate == createdDate) {
        found = true;
        break;
      }

    if (found == false) decks.add(deck);

    return !found;
  }
}
