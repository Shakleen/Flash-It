import 'package:flash_it/models/entities/deck_model.dart';
import 'package:test/test.dart';

void main() {
  group('Deck Model Test', () {
    test('Creating deck object', createDeckObject);
    test('Creating deck object from map', createDeckFromMap);
    test('Creating map from deck object', createMapFromDeck);
  });
}

void createDeckObject() {
  final String name = "Topic name";
  final String description = "Topic description";
  final DateTime creationDate = DateTime.now();
  final DateTime lastViewedDate = DateTime.now().subtract(Duration(hours: 3));
  final int id = 0;
  final int topicId = 0;
  final DeckModel deckModel = DeckModel(
    name: name,
    description: description,
    creationDate: creationDate,
    lastViewedDate: lastViewedDate,
    id: id,
    topicID: topicId,
  );

  expect(deckModel.name, name);
  expect(deckModel.description, description);
  expect(deckModel.creationDate, creationDate);
  expect(deckModel.lastViewedDate, lastViewedDate);
  expect(deckModel.id, id);
  expect(deckModel.topicID, topicId);
}

void createDeckFromMap() {
  final Map<String, dynamic> input = {};
  input['name'] = "Topic name";
  input['description'] = "Topic description";
  input['creationDate'] = DateTime.now();
  input['lastViewedDate'] = DateTime.now().subtract(Duration(hours: 3));
  input['id'] = 0;
  input['topicID'] = 0;

  final DeckModel deckModel = DeckModel.fromMap(input);

  expect(deckModel.name, input['name']);
  expect(deckModel.description, input['description']);
  expect(deckModel.creationDate, input['creationDate']);
  expect(deckModel.lastViewedDate, input['lastViewedDate']);
  expect(deckModel.id, input['id']);
  expect(deckModel.topicID, input['topicID']);
}

void createMapFromDeck() {
  final DeckModel deckModel = DeckModel(
    name: "Topic name",
    description: "Topic description",
    creationDate: DateTime.now(),
    lastViewedDate: DateTime.now().subtract(Duration(hours: 3)),
    id: 0,
    topicID: 0,
  );

  final Map<String, dynamic> output = deckModel.toMap();

  expect(deckModel.name, output['name']);
  expect(deckModel.description, output['description']);
  expect(deckModel.creationDate, output['creationDate']);
  expect(deckModel.lastViewedDate, output['lastViewedDate']);
  expect(deckModel.id, output['id']);
  expect(deckModel.topicID, output['topicID']);
}
