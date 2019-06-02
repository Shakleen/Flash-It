import 'dart:async';

import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/controllers/file_controller/deck_file.dart';
import 'package:flash_it/models/database/card_database.dart';
import 'package:flash_it/models/database/deck_database.dart';
import 'package:flash_it/models/entities/deck_model.dart';

class DeckDatabaseBloc implements BlocBase {
  final StreamController<List<Map<String, dynamic>>> deckSC =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final int topicID;

  final StreamTransformer<List<Map<String, dynamic>>, List<DeckModel>>
      _transformer = StreamTransformer<List<Map<String, dynamic>>,
          List<DeckModel>>.fromHandlers(
    handleData: _handleData,
    handleDone: _handleDone,
    handleError: _handleError,
  );

  DeckDatabaseBloc({this.topicID}) {
    DeckDatabase.deckDatabase.topicID = this.topicID;
    getItems();
  }

  Stream<List<DeckModel>> get decks => deckSC.stream.transform(_transformer);

  void getItems() async =>
      deckSC.sink.add(await DeckDatabase.deckDatabase.getItems());

  @override
  void dispose() {
    deckSC.close();
  }

  static void _handleDone(EventSink<List<DeckModel>> sink) {}

  static void _handleData(
    List<Map<String, dynamic>> data,
    EventSink<List<DeckModel>> sink,
  ) {
    final List<DeckModel> decks = [];
    if (data != null)
      for (Map<String, dynamic> element in data)
        decks.add(DeckModel.fromMap(element));
    sink.add(decks);
  }

  static void _handleError(
    Object error,
    StackTrace stackTrace,
    EventSink<List<DeckModel>> sink,
  ) {}

  Future<bool> insert(Map<String, dynamic> input) {
    final DateTime now = DateTime.now();
    final String nowstr = DateTime(now.year, now.month, now.day).toString();
    input[deckAttributes[3][0]] = nowstr;
    input[deckAttributes[4][0]] = nowstr;
    return DeckDatabase.deckDatabase.insert(input).then((bool status) {
      if (status) {
        DeckFile.deckFile.add(input);
        getItems();
      }
      return status;
    });
  }

  Future<bool> delete(dynamic deck) {
    return DeckDatabase.deckDatabase.delete(deck.toMap()).then((bool status) {
      if (status) {
        DeckFile.deckFile.remove(deck.toMap());
        getItems();
      }
      return status;
    });
  }

  Future<bool> update(Map<String, dynamic> input, Map<String, dynamic> old) {
    final DateTime now = DateTime.now();
    final String nowstr = DateTime(now.year, now.month, now.day).toString();
    input[deckAttributes[3][0]] = nowstr;
    input[deckAttributes[4][0]] = nowstr;
    return DeckDatabase.deckDatabase.update(input).then((bool status) {
      if (status) {
        DeckFile.deckFile.update(old, input);
        getItems();
      }
      return status;
    });
  }

  Future<bool> updateLastViewed(DeckModel deck) {
    final DateTime now = DateTime.now();
    DeckModel newDeck = DeckModel(
      name: deck.name,
      description: deck.description,
      creationDate: deck.creationDate,
      lastViewedDate: DateTime(now.year, now.month, now.day),
      id: deck.id,
      topicID: deck.topicID,
    );
    return DeckDatabase.deckDatabase
        .update(newDeck.toMap())
        .then((bool status) {
      if (status) {
        DeckFile.deckFile.update(deck.toMap(), newDeck.toMap());
        getItems();
      }
      return status;
    });
  }

  Future<int> getTotal() => DeckDatabase.deckDatabase.getItemCount();

  Future<int> getCardsNumber(int deckID) =>
      CardDatabase.cardDatabase.getItemCount(deckID: deckID);
}
