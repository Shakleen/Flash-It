import 'dart:async';

import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/controllers/file_controller/card_file.dart';
import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/models/database/card_database.dart';
import 'package:flash_it/models/entities/card_model.dart';

class CardDatabaseBloc implements BlocBase {
  final StreamController<List<Map<String, dynamic>>> _allCardsSC =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final StreamController<List<Map<String, dynamic>>> _quizCardsSC =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final int deckID;
  static bool _important;

  final StreamTransformer<List<Map<String, dynamic>>, List<CardModel>>
      _transformer = StreamTransformer<List<Map<String, dynamic>>,
          List<CardModel>>.fromHandlers(
    handleData: _handleData,
    handleDone: _handleDone,
    handleError: _handleError,
  );

  CardDatabaseBloc({this.deckID}) {
    CardDatabase.cardDatabase.deckID = this.deckID;
    getItems();
    getQuizCards();
    _important = false;
  }

  void toggleImportant() {
    _important = !_important;
    getItems();
  }

  Stream<List<CardModel>> get cards =>
      _allCardsSC.stream.transform(_transformer);

  Stream<List<CardModel>> get quizCards =>
      _quizCardsSC.stream.transform(_transformer);

  void getItems() async =>
      _allCardsSC.sink.add(await CardDatabase.cardDatabase.getItems());

  void getQuizCards() async =>
      _quizCardsSC.sink.add(await CardDatabase.cardDatabase.getQuizCards());

  @override
  void dispose() {
    _quizCardsSC.close();
    _allCardsSC.close();
  }

  static void _handleDone(EventSink<List<CardModel>> sink) {}

  static void _handleData(
    List<Map<String, dynamic>> data,
    EventSink<List<CardModel>> sink,
  ) {
    List<CardModel> cards = [];
    if (data != null)
      for (Map<String, dynamic> element in data) {
        final CardModel cardModel = CardModel.fromMap(element);
        if ((_important && cardModel.important) || !_important)
          cards.add(cardModel);
      }
    sink.add(cards);
  }

  static void _handleError(
    Object error,
    StackTrace stackTrace,
    EventSink<List<CardModel>> sink,
  ) {}

  Future<bool> insert(Map<String, dynamic> input) {
    input[cardAttributes[0][0]] = EditUserSettings.edit.settings.cards;
    input[cardAttributes[6][0]] = getCurrentDateAsString();
    return CardDatabase.cardDatabase.insert(input).then((bool status) {
      if (status) {
        EditUserSettings.edit.incrementCardCount();
        CardFile.cardFile.add(input);
        getItems();
      }
      return status;
    });
  }

  Future<bool> delete(dynamic card) {
    return CardDatabase.cardDatabase.delete(card.toMap()).then((bool status) {
      if (status) {
        CardFile.cardFile.remove(card.toMap());
        getItems();
      }
      return status;
    });
  }

  Future<bool> update(Map<String, dynamic> newValue,
      Map<String, dynamic> oldValue,) {
    newValue[cardAttributes[6][0]] = getCurrentDateAsString();
    newValue[cardAttributes[4][0]] = 0;
    return updateDatabase(
      CardModel.fromMap(oldValue),
      CardModel.fromMap(newValue),
    );
  }

  Future<bool> markImportant(CardModel newValue) {
    final CardModel oldValue = CardModel(
      question: newValue.question,
      answer: newValue.answer,
      memoryState: newValue.memoryState,
      cardID: newValue.cardID,
      deckID: newValue.deckID,
      important: !newValue.important,
      nextQuizDate: newValue.nextQuizDate,
    );
    return updateDatabase(newValue, oldValue);
  }

  Future<int> getTotal() => CardDatabase.cardDatabase.getItemCount();

  Future<bool> guessedCorrect(CardModel newValue) {
    final int memState = newValue.memoryState + 1;
    DateTime after = newValue.nextQuizDate;
    if (after.isBefore(DateTime.now())) after = DateTime.now();
    final DateTime nextQuiz = after.add(Duration(hours: 8 * memState));
    final CardModel oldValue = CardModel(
      question: newValue.question,
      answer: newValue.answer,
      memoryState: memState,
      cardID: newValue.cardID,
      deckID: newValue.deckID,
      important: newValue.important,
      nextQuizDate: nextQuiz,
    );
    return updateDatabase(oldValue, newValue);
  }

  Future<bool> guessedWrong(CardModel oldValue) {
    final CardModel newValue = CardModel(
      question: oldValue.question,
      answer: oldValue.answer,
      memoryState: 0,
      cardID: oldValue.cardID,
      deckID: oldValue.deckID,
      important: oldValue.important,
      nextQuizDate: DateTime.now(),
    );
    return updateDatabase(newValue, oldValue);
  }

  Future<bool> updateDatabase(CardModel oldValue, CardModel newValue) async =>
      CardDatabase.cardDatabase.update(newValue.toMap()).then((bool status) {
        if (status) {
          CardFile.cardFile.update(oldValue.toMap(), newValue.toMap());
          getItems();
        }
        return status;
      });
}
