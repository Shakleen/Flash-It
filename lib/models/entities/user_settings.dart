import 'package:flash_it/models/entities/base_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class UserSettings {
  bool loggedIn;
  int appThemeColor, cardsPerQuiz;
  DateTime notificationTime, syncTime;
  String topicDBFileID, deckDBFileID, cardDBFileID, settingsFileID;

  UserSettings({
    @required this.loggedIn,
    @required this.appThemeColor,
    @required this.cardsPerQuiz,
    @required this.notificationTime,
    @required this.syncTime,
    @required this.topicDBFileID,
    @required this.deckDBFileID,
    @required this.cardDBFileID,
    @required this.settingsFileID,
  });

  factory UserSettings.basic() => UserSettings(
        loggedIn: false,
        appThemeColor: 2,
        cardsPerQuiz: 10,
        notificationTime: DateTime(2019, 4, 1, 8, 0, 0, 0, 0),
        syncTime: DateTime(2019, 4, 1, 8, 0, 0, 0, 0),
        topicDBFileID: null,
        deckDBFileID: null,
        cardDBFileID: null,
        settingsFileID: null,
      );

  factory UserSettings.fromMap(Map<String, dynamic> input) => UserSettings(
        loggedIn: convertBool(input[userSettingParams[0]]),
        appThemeColor: convertInt(input[userSettingParams[1]]),
        cardsPerQuiz: convertInt(input[userSettingParams[2]]),
        notificationTime: convertDateTime(input[userSettingParams[3]]),
        syncTime: convertDateTime(input[userSettingParams[4]]),
        topicDBFileID: input[userSettingParams[5]],
        deckDBFileID: input[userSettingParams[6]],
        cardDBFileID: input[userSettingParams[7]],
        settingsFileID: input[userSettingParams[8]],
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> output = {};

    for (int key in userSettingParams.keys)
      output[userSettingParams[key]] = this.getAttribute(key);

    return output;
  }

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
        return this.topicDBFileID;
      case 6:
        return this.deckDBFileID;
      case 7:
        return this.cardDBFileID;
      case 8:
        return this.settingsFileID;
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
  5: 'topicDBFileID',
  6: 'deckDBFileID',
  7: 'cardDBFileID',
  8: 'settingsFileID',
};
