import 'dart:convert';

import 'package:flash_it/controllers/file_controller/user_files.dart';
import 'package:flash_it/models/database/card_database.dart';
import 'package:flash_it/models/entities/card_model.dart';

/// Class for handling the reading, writing and manipulation of the card.json
/// file.
///
/// The class rewrites the card.json file upon new card addition, deletion and
/// information update.
///
/// [cards] - A list of [CardModel] type objects that temporarily stores the
/// cards in between reading and writing.
///
/// [CardFile] - Singleton for this class.
class CardFile {
  static final CardFile cardFile = CardFile._();
  final List<CardModel> cards = [];

  /// Private constructor.
  CardFile._();

  /// Add a new card to the file card.json
  void add(Map<String, dynamic> input) => _process(input, _addTocard);

  /// Remove a card from the file card.json
  void remove(Map<String, dynamic> input) => _process(input, _deleteFromcards);

  /// Update value of a card in file card.json
  void update(Map<String, dynamic> value, Map<String, dynamic> newValue) =>
      _process(
        value,
        _deleteFromcards,
        op2: _addTocard,
        newValue: newValue,
      );

  /// Method to recreate the database from the information in the files.
  void createDatabase() async {
    await _read();

    for (CardModel card in cards)
      CardDatabase.cardDatabase.insert(card.toMap());
  }

  /// Private method for reading, decoding and adding contents of the file
  /// card.json to the list [cards].
  Future<void> _read() async {
    final String debug = "CardFile - _read"; // TODO DEBUG
    final String content = await UserFiles.files.cardJsonContentString;
    print(
        "$debug content of type ${content.runtimeType} is $content"); // TODO DEBUG
    cards.clear();
    if (content != null) if (content.isNotEmpty) {
      List<dynamic> read = json.decode(content);
      cards.addAll(
        read.map((dynamic item) => CardModel.fromMap(item)).toList(),
      );
    }
  }

  /// Private method for encoding and writing the contents of [cards] into
  /// the file cards.json
  Future<void> _write() async {
    final String debug = "CardFile - _write"; // TODO DEBUG
    final List<Map<String, dynamic>> jsonFormat = [];
    for (CardModel card in cards) jsonFormat.add(card.toMap());
    final String content = json.encode(jsonFormat);
    print(
        '$debug content of type ${content.runtimeType} is $content'); // TODO DEBUG
    UserFiles.files.write(
      content,
      await UserFiles.files.cardJson,
      await UserFiles.files.cardJsonPath,
    );
  }

  /// Private method to manipulate the contents of the file card.json
  ///
  /// This method first reads from the file card.json to get all its contents.
  /// Then it performs the [op1] with [value] as an argument, which can be add
  /// or remove. Then depending on the value of the [newValue] variable it may
  /// run [op2] with [newValue] passed as an argument.
  void _process(
    Map<String, dynamic> value,
    Function(CardModel value) op1, {
    Function(CardModel value) op2,
    Map<String, dynamic> newValue,
  }) async {
    await _read();
    print("Value received is $value");
    for (CardModel card in cards) print('${card.toMap()}');
    print(op1(CardModel.fromMap(value)));
    if (newValue != null) op2(CardModel.fromMap(newValue));
    _write();
  }

  /// Private method to check and delete appropriate card from the list [cards].
  ///
  /// The method compares the set dates to identify the appropriate card. As
  /// the set time is accurate upto the microsecond it is impossible for two
  /// cards to have the same creation time. If a match is found then [card] is
  /// deleted from [cards].
  bool _deleteFromcards(CardModel card) {
    for (int i = 0; i < cards.length; ++i)
      if (cards[i].cardID == card.cardID) {
        cards.removeAt(i);
        return true;
      }
    return false;
  }

  /// Private method to check and add card to the list [cards].
  ///
  /// The method compares the set dates to identify appropriate card. As
  /// the set time is accurate upto the microsecond it is impossible for two
  /// cards to have the same creation time. If a card with the same set date
  /// exists in the list then [card] isn't added.
  bool _addTocard(CardModel card) {
    bool found = false;

    for (int i = 0; i < cards.length; ++i)
      if (cards[i].cardID == card.cardID) {
        found = true;
        break;
      }

    if (found == false) cards.add(card);

    return !found;
  }
}
