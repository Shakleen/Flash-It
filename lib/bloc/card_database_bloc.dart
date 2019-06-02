import 'dart:async';

import 'package:flash_it/bloc/bloc_provider.dart';
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
    final DateTime now = DateTime.now();
    input[cardAttributes[6][0]] =
        DateTime(now.year, now.month, now.day).toString();
    return CardDatabase.cardDatabase.insert(input).then((bool status) {
      if (status) getItems();
      return status;
    });
  }

  Future<bool> delete(dynamic card) {
    return CardDatabase.cardDatabase.delete(card.toMap()).then((bool status) {
      if (status) getItems();
      return status;
    });
  }

  Future<bool> update(Map<String, dynamic> input, Map<String, dynamic> old) {
    final DateTime now = DateTime.now();
    input[cardAttributes[6][0]] =
        DateTime(now.year, now.month, now.day).toString();
    input[cardAttributes[4][0]] = 0;
    return CardDatabase.cardDatabase.update(input).then((bool status) {
      if (status) getItems();
      return status;
    });
  }

  Future<bool> markImportant(CardModel cardModel) {
    final CardModel card = CardModel(
      question: cardModel.question,
      answer: cardModel.answer,
      memoryState: cardModel.memoryState,
      cardID: cardModel.cardID,
      deckID: cardModel.deckID,
      important: !cardModel.important,
      nextQuizDate: cardModel.nextQuizDate,
    );
    return CardDatabase.cardDatabase.update(card.toMap()).then((bool status) {
      if (status) getItems();
      return status;
    });
  }

  Future<int> getTotal() => CardDatabase.cardDatabase.getItemCount();

  Future<bool> guessedCorrect(CardModel cardModel) {
    final int memState = cardModel.memoryState + 1;
    DateTime after = cardModel.nextQuizDate;
    if (after.isBefore(DateTime.now())) after = DateTime.now();
    final DateTime nextQuiz = after.add(Duration(hours: 12 * memState));
    final CardModel card = CardModel(
      question: cardModel.question,
      answer: cardModel.answer,
      memoryState: memState,
      cardID: cardModel.cardID,
      deckID: cardModel.deckID,
      important: cardModel.important,
      nextQuizDate: nextQuiz,
    );
    return CardDatabase.cardDatabase.update(card.toMap()).then((bool status) {
      if (status) getItems();
      return status;
    });
  }

  Future<bool> guessedWrong(CardModel cardModel) {
    final CardModel card = CardModel(
      question: cardModel.question,
      answer: cardModel.answer,
      memoryState: 0,
      cardID: cardModel.cardID,
      deckID: cardModel.deckID,
      important: cardModel.important,
      nextQuizDate: cardModel.nextQuizDate,
    );
    return CardDatabase.cardDatabase.update(card.toMap()).then((bool status) {
      if (status) getItems();
      return status;
    });
  }
}
