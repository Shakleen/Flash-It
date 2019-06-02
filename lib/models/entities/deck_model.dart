import 'package:flash_it/models/entities/base_model.dart';
import 'package:flash_it/models/entities/topic_model.dart';
import 'package:meta/meta.dart';

class DeckModel implements BaseModel {
  final String name, description;
  final DateTime creationDate, lastViewedDate;
  final int id, topicID;

  DeckModel({
    @required this.name,
    @required this.description,
    @required this.creationDate,
    @required this.lastViewedDate,
    @required this.id,
    @required this.topicID,
  });

  factory DeckModel.fromMap(Map<String, dynamic> input) => DeckModel(
        id: convertInt(input[deckAttributes[0][0]]),
        name: input[deckAttributes[1][0]],
        description: input[deckAttributes[2][0]],
        creationDate: convertDateTime(input[deckAttributes[3][0]]),
        lastViewedDate: convertDateTime(input[deckAttributes[4][0]]),
        topicID: convertInt(input[deckAttributes[5][0]]),
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> output = {};

    output[deckAttributes[0][0]] = this.id.toString();
    output[deckAttributes[1][0]] = this.name;
    output[deckAttributes[2][0]] = this.description;
    output[deckAttributes[3][0]] = this.creationDate.toString();
    output[deckAttributes[4][0]] = this.lastViewedDate.toString();
    output[deckAttributes[5][0]] = this.topicID.toString();

    return output;
  }

  @override
  getAttribute(int key) {
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
      case 5:
        return this.topicID;
    }

    return null;
  }
}

final Map<int, List<String>> deckAttributes = const {
  0: ['id', 'INTEGER', 'PRIMARY KEY AUTOINCREMENT'],
  1: ['name', 'TEXT', 'NOT NULL'],
  2: ['description', 'TEXT', 'NOT NULL'],
  3: ['creationDate', 'DATETIME', 'NOT NULL'],
  4: ['lastViewedDate', 'DATETIME', 'NOT NULL'],
  5: ['topicID', 'INTEGER', 'NOT NULL'],
};

final String deckFKTable =
        "FOREIGN KEY($deckFK) REFERENCES " + "$topicTable ($topicPK)",
    deckPK = deckAttributes[0][0],
    deckFK = deckAttributes[5][0],
    deckTable = "Decks";

final Map<String, dynamic> deckFormData = {
  deckAttributes[0][0]: null,
  deckAttributes[1][0]: null,
  deckAttributes[2][0]: null,
  deckAttributes[3][0]: null,
  deckAttributes[4][0]: null,
  deckAttributes[5][0]: null,
};
