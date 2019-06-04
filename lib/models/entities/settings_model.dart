import 'package:flash_it/models/entities/base_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Class that handles the settings and iner workings of the application.
///
/// Houses important values that are important to maintain settings and other
/// functionalities of the application.
///
/// [loggedIn] - Checks if the user is logged into their google account.
/// [appThemeColor] - Which app theme color is selected.
/// [cardsPerQuiz] - How many cards to review in a single  quiz.
/// [topics] - How many topics are currently created in the application.
/// [decks] - Hom many decks are currently in the application.
/// [cards] - How many cards are created by the user.
/// [notificationTime] - The selected time of the day to remind the user to
/// review and quiz the cards.
/// [syncTime] - The time of the day to sync with the cloud to save user data.
/// [topicFileID] - The file ID of the topic file that keeps all the topic
/// related information. This ID is given by the google drive system.
/// [deckFileID] - The file ID of the deck file that keeps all the deck
/// related information. This ID is given by the google drive system.
/// [cardFileID] - The file ID of the card file that keeps all the card
/// related information. This ID is given by the google drive system.
class SettingsModel implements BaseModel {
  bool loggedIn;
  int appThemeColor, cardsPerQuiz, topics, decks, cards;
  DateTime notificationTime, syncTime;
  String topicFileID, deckFileID, cardFileID, settingsFileID;

  /// Default constructor to create the object.
  SettingsModel({
    @required this.loggedIn,
    @required this.appThemeColor,
    @required this.cardsPerQuiz,
    @required this.notificationTime,
    @required this.syncTime,
    @required this.topicFileID,
    @required this.deckFileID,
    @required this.cardFileID,
    @required this.settingsFileID,
    @required this.topics,
    @required this.decks,
    @required this.cards,
  });


  /// Method to create a basic UserSettings object. The values are predefined.
  factory SettingsModel.basic() =>
      SettingsModel(
        loggedIn: false,
        appThemeColor: 2,
        cardsPerQuiz: 10,
        notificationTime: DateTime(2019, 4, 1, 8, 0, 0, 0, 0),
        syncTime: DateTime(2019, 4, 1, 8, 0, 0, 0, 0),
        topicFileID: null,
        deckFileID: null,
        cardFileID: null,
        settingsFileID: null,
        topics: 0,
        decks: 0,
        cards: 0,
      );


  /// Method to create a UserSettings object from a map variable called [input].
  factory SettingsModel.fromMap(Map<String, dynamic> input) =>
      SettingsModel(
        loggedIn: convertBool(input[userSettingParams[0]]),
        appThemeColor: convertInt(input[userSettingParams[1]]),
        cardsPerQuiz: convertInt(input[userSettingParams[2]]),
        notificationTime: convertDateTime(input[userSettingParams[3]]),
        syncTime: convertDateTime(input[userSettingParams[4]]),
        topicFileID: input[userSettingParams[5]],
        deckFileID: input[userSettingParams[6]],
        cardFileID: input[userSettingParams[7]],
        settingsFileID: input[userSettingParams[8]],
        topics: convertInt(input[userSettingParams[9]]),
        decks: convertInt(input[userSettingParams[10]]),
        cards: convertInt(input[userSettingParams[11]]),
      );


  /// Method that turns the object into a map.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> output = {};

    for (int key in userSettingParams.keys)
      output[userSettingParams[key]] = this.getAttribute(key);

    return output;
  }

  /// Method to get the value of the attribute represented by the [key]
  dynamic getAttribute(int key) {
    switch (key) {
      case 0:
        return this.loggedIn.toString();
      case 1:
        return this.appThemeColor.toString();
      case 2:
        return this.cardsPerQuiz.toString();
      case 3:
        return this.notificationTime.toString();
      case 4:
        return this.syncTime.toString();
      case 5:
        return this.topicFileID;
      case 6:
        return this.deckFileID;
      case 7:
        return this.cardFileID;
      case 8:
        return this.settingsFileID;
      case 9:
        return this.topics.toString();
      case 10:
        return this.decks.toString();
      case 11:
        return this.cards.toString();
    }
    return null;
  }
}

final Map<int, String> userSettingParams = const {
  0: 'loggedIn',
  1: 'appThemeColor',
  2: 'cardsPerQuiz',
  3: 'notificationTime',
  4: 'syncTime',
  5: 'topicFileID',
  6: 'deckFileID',
  7: 'cardFileID',
  8: 'settingsFileID',
  9: 'topics',
  10: 'decks',
  11: 'cards',
};
