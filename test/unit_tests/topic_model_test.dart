import 'package:flash_it/models/entities/topic_model.dart';
import 'package:test/test.dart';

void main() {
  group('Topic Model Test', () {
    test('Creating topic object', createTopicObject);
    test('Creating topic object from map', createTopicFromMap);
    test('Creating map from topic object', createMapFromTopic);
  });
}

void createTopicObject() {
  final String name = "Topic name";
  final String description = "Topic description";
  final DateTime creationDate = DateTime.now();
  final DateTime lastViewedDate = DateTime.now().subtract(Duration(hours: 3));
  final int id = 0;
  final TopicModel topicModel = TopicModel(
    name: name,
    description: description,
    creationDate: creationDate,
    lastViewedDate: lastViewedDate,
    id: id,
  );

  expect(topicModel.name, name);
  expect(topicModel.description, description);
  expect(topicModel.creationDate, creationDate);
  expect(topicModel.lastViewedDate, lastViewedDate);
  expect(topicModel.id, id);
}

void createTopicFromMap() {
  final Map<String, dynamic> input = {};
  input['name'] = "Topic name";
  input['description'] = "Topic description";
  input['creationDate'] = DateTime.now();
  input['lastViewedDate'] = DateTime.now().subtract(Duration(hours: 3));
  input['id'] = 0;

  final TopicModel topicModel = TopicModel.fromMap(input);

  expect(topicModel.name, input['name']);
  expect(topicModel.description, input['description']);
  expect(topicModel.creationDate, input['creationDate']);
  expect(topicModel.lastViewedDate, input['lastViewedDate']);
  expect(topicModel.id, input['id']);
}

void createMapFromTopic() {
  final TopicModel topicModel = TopicModel(
    name: "Topic name",
    description: "Topic description",
    creationDate: DateTime.now(),
    lastViewedDate: DateTime.now().subtract(Duration(hours: 3)),
    id: 0,
  );

  final Map<String, dynamic> output = topicModel.toMap();

  expect(topicModel.name, output['name']);
  expect(topicModel.description, output['description']);
  expect(topicModel.creationDate.toString(), output['creationDate']);
  expect(topicModel.lastViewedDate.toString(), output['lastViewedDate']);
  expect(topicModel.id.toString(), output['id']);
}
