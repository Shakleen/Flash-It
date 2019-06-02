import 'package:flash_it/models/entities/base_model.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:meta/meta.dart';

class CardModel implements BaseModel {
  final String question, answer;
  final int memoryState, cardID, deckID;
  final bool important;
  final DateTime nextQuizDate;

  CardModel({
    @required this.question,
    @required this.answer,
    @required this.memoryState,
    @required this.cardID,
    @required this.deckID,
    @required this.important,
    @required this.nextQuizDate,
  });

  factory CardModel.fromMap(Map<String, dynamic> input) => CardModel(
        cardID: convertInt(input[cardAttributes[0][0]]),
        deckID: convertInt(input[cardAttributes[1][0]]),
        question: input[cardAttributes[2][0]],
        answer: input[cardAttributes[3][0]],
        memoryState: convertInt(input[cardAttributes[4][0]]),
        important: convertBool(input[cardAttributes[5][0]]),
        nextQuizDate: convertDateTime(input[cardAttributes[6][0]]),
      );

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> output = {};

    output[cardAttributes[0][0]] = this.cardID.toString();
    output[cardAttributes[1][0]] = this.deckID.toString();
    output[cardAttributes[2][0]] = this.question;
    output[cardAttributes[3][0]] = this.answer;
    output[cardAttributes[4][0]] = this.memoryState.toString();
    output[cardAttributes[5][0]] = this.important.toString();
    output[cardAttributes[6][0]] = this.nextQuizDate.toString();

    return output;
  }

  @override
  getAttribute(int key) {
    switch (key) {
      case 0:
        return this.cardID;
      case 1:
        return this.deckID;
      case 2:
        return this.question;
      case 3:
        return this.answer;
      case 4:
        return this.memoryState;
      case 5:
        return this.important;
      case 6:
        return this.nextQuizDate;
    }
    return null;
  }
}

final Map<int, List<String>> cardAttributes = const {
  0: ['cardID', 'INTEGER', 'PRIMARY KEY AUTOINCREMENT'],
  1: ['deckID', 'INTEGER', 'NOT NULL'],
  2: ['question', 'TEXT', 'NOT NULL'],
  3: ['answer', 'TEXT', 'NOT NULL'],
  4: ['memoryState', 'INTEGER', 'NOT NULL'],
  5: ['important', 'BOOLEAN', 'NOT NULL'],
  6: ['nextQuizDate', 'DATETIME', 'NOT NULL'],
};

final String cardPK = cardAttributes[0][0],
    cardFK = cardAttributes[1][0],
    cardFKTable = "FOREIGN KEY($cardFK) REFERENCES " + "$deckTable ($deckPK)",
    cardTable = "Cards";

final Map<String, dynamic> cardFormData = {
  cardAttributes[0][0]: null,
  cardAttributes[1][0]: null,
  cardAttributes[2][0]: null,
  cardAttributes[3][0]: null,
  cardAttributes[4][0]: 0,
  cardAttributes[5][0]: false,
  cardAttributes[6][0]: null,
};
