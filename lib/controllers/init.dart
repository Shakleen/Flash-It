import 'dart:async';

import 'package:flash_it/models/database/card_database.dart';
import 'package:flash_it/models/database/deck_database.dart';
import 'package:flash_it/models/database/topic_database.dart';
import 'package:flash_it/models/entities/card_model.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:flash_it/models/entities/topic_model.dart';

class Init {
  void printDatabaseStatus() async {
    final int totalTopics = await TopicDatabase.topicDatabase.getItemCount();
    final int totalDecks = await DeckDatabase.deckDatabase.getItemCount();
    final int totalCards = await CardDatabase.cardDatabase.getItemCount();

    print('Total topics: $totalTopics');
    print('Total decks: $totalDecks');
    print('Total cards: $totalCards');
  }

  Future<bool> init() async {
    await TopicDatabase.topicDatabase.initDatabase().then(_afterTopicDatabase);
//    printDatabaseStatus();
    return true;
  }

  FutureOr _afterTopicDatabase(bool status) async {
//    print('Topic Database status: ${status ? 'Live' : 'Down'}');
    if (status)
      await DeckDatabase.deckDatabase.initDatabase().then(_afterDeckDatabase);
    return status;
  }

  FutureOr _afterDeckDatabase(bool value) async {
//    print('Deck Database status: ${value ? 'Live' : 'Down'}');
    if (value)
      await CardDatabase.cardDatabase.initDatabase().then(_afterCardDatabase);
    return value;
  }

  FutureOr _afterCardDatabase(bool value) async {
//    print('Card Database status: ${value ? 'Live' : 'Down'}');
//  if (value) await _populateWithValues();
    return value;
  }

  void _populateWithValues() async {
//    print('Inserting values into tables');
    final int topics = 10, decks = 10, cards = 25;
    int curDeck = 1, curCard = 1;

    for (int i = 1; i <= topics; ++i) {
      await TopicDatabase.topicDatabase.insert(TopicModel(
        id: i,
        creationDate: DateTime.now().add(Duration(seconds: i)),
        name: "Topic $i",
        description: "Topic description $i",
        lastViewedDate: DateTime.now().add(Duration(seconds: i)),
      ).toMap());

      for (int j = 1; j <= decks; ++j) {
        await DeckDatabase.deckDatabase.insert(DeckModel(
          id: curDeck,
          topicID: i,
          lastViewedDate: DateTime.now().add(Duration(seconds: i)),
          description: "Deck for topic $i",
          name: "Deck $j",
          creationDate: DateTime.now().add(Duration(seconds: i)),
        ).toMap());

        for (int k = 1; k <= cards; ++k, ++curCard) {
          await CardDatabase.cardDatabase.insert(CardModel(
                  nextQuizDate: DateTime.now().subtract(Duration(days: k)),
                  deckID: curDeck,
                  cardID: curCard,
                  important: curCard % 3 == 0,
                  memoryState: curCard % 10,
                  answer: 'Card for deck $curDeck of topic $i',
                  question: 'Card $curCard')
              .toMap());
        }

        ++curDeck;
      }
    }
//    print('Insertion done!');
  }
}

final Init init = Init();
