import 'package:flash_it/models/entities/base_model.dart';
import 'package:meta/meta.dart';

class TopicModel implements BaseModel {
  final String name, description;
  final DateTime creationDate, lastViewedDate;
  final int id;

  TopicModel({
    @required this.name,
    @required this.description,
    @required this.creationDate,
    @required this.lastViewedDate,
    @required this.id,
  });

  factory TopicModel.fromMap(Map<String, dynamic> input) => TopicModel(
        id: convertInt(input[topicAttributes[0][0]]),
        name: input[topicAttributes[1][0]],
        description: input[topicAttributes[2][0]],
        creationDate: convertDateTime(input[topicAttributes[3][0]]),
        lastViewedDate: convertDateTime(input[topicAttributes[4][0]]),
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> output = {};

    output[topicAttributes[0][0]] = this.id.toString();
    output[topicAttributes[1][0]] = this.name;
    output[topicAttributes[2][0]] = this.description;
    output[topicAttributes[3][0]] = this.creationDate.toString();
    output[topicAttributes[4][0]] = this.lastViewedDate.toString();

    return output;
  }

  dynamic getAttribute(int key) {
    switch (key) {
      case 0:
        return this.id;
      case 1:
        return this.name;
      case 2:
        return this.description;
      case 3:
        return this.creationDate;
      case 4:
        return this.lastViewedDate;
    }

    return null;
  }
}

final Map<int, List<String>> topicAttributes = const {
  0: ['id', 'INTEGER', 'PRIMARY KEY'],
  1: ['name', 'TEXT', 'NOT NULL'],
  2: ['description', 'TEXT', 'NOT NULL'],
  3: ['creationDate', 'DATETIME', 'NOT NULL'],
  4: ['lastViewedDate', 'DATETIME', 'NOT NULL'],
};
final String topicTable = "Topics", topicPK = topicAttributes[0][0];
final Map<String, dynamic> topicFormData = {
  topicAttributes[0][0]: null,
  topicAttributes[1][0]: null,
  topicAttributes[2][0]: null,
  topicAttributes[3][0]: null,
  topicAttributes[4][0]: null,
};
