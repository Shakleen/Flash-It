import 'dart:convert';

import 'package:flash_it/controllers/file_controller/user_files.dart';
import 'package:flash_it/models/entities/topic_model.dart';

/// Class for handling the reading, writing and manipulation of the topic.json
/// file.
///
/// The class rewrites the topic.json file upon new topic addition, deletion and
/// information update.
///
/// [topics] - A list of [TopicModel] type objects that temporarily stores the
/// topics in between reading and writing.
///
/// [topicFile] - Singleton for this class.
class TopicFile {
  static final TopicFile topicFile = TopicFile._();
  final List<TopicModel> topics = [];

  /// Private constructor.
  TopicFile._();

  /// Add a new topic to the file topic.json
  void add(Map<String, dynamic> input) => _process(input, _addToTopic);

  /// Remove a topic from the file topic.json
  void remove(Map<String, dynamic> input) => _process(input, _deleteFromTopics);

  /// Update value of a topic in file topic.json
  void update(Map<String, dynamic> value, Map<String, dynamic> newValue) =>
      _process(
        value,
        _deleteFromTopics,
        op2: _addToTopic,
        newValue: newValue,
      );

  /// Helper method for reading, decoding and adding contents of the file
  /// topic.json to the list [topics].
  Future<void> _read() async {
    final String debug = "TopicFile - _read"; // TODO DEBUG
    final String content = await UserFiles.files.topicJsonContentString;
    print(
        "$debug content of type ${content.runtimeType} is $content"); // TODO DEBUG
    topics.clear();
    if (content != null) if (content.isNotEmpty) {
      List<dynamic> read = json.decode(content);
      topics.addAll(
        read.map((dynamic item) => TopicModel.fromMap(item)).toList(),
      );
    }
  }

  /// Helper method for encoding and writing the contents of [topics] into
  /// the file topics.json
  Future<void> _write() async {
    final String debug = "TopicFile - _write"; // TODO DEBUG
    final List<Map<String, dynamic>> jsonFormat = [];
    for (TopicModel topic in topics) jsonFormat.add(topic.toMap());
    final String content = json.encode(jsonFormat);
    print(
        '$debug content of type ${content.runtimeType} is $content'); // TODO DEBUG
    UserFiles.files.write(
      content,
      await UserFiles.files.topicJson,
      await UserFiles.files.topicJsonPath,
    );
  }

  /// Helper method to manipulate the contents of the tile topic.json
  ///
  /// This method first reads from the file topic.json to get all its contents.
  /// Then it performs the [op1] with [value] as an argument, which can be add
  /// or remove. Then depending on the value of the [newValue] variable it may
  /// run [op2] with [newValue] passed as an argument.
  void _process(
    Map<String, dynamic> value,
    Function(TopicModel value) op1, {
    Function(TopicModel value) op2,
    Map<String, dynamic> newValue,
  }) async {
    value['id'] = null;
    await _read();
    print("Value received is $value");
    for (TopicModel topic in topics) print('${topic.toMap()}');
    print(op1(TopicModel.fromMap(value)));
    if (newValue != null) {
      newValue['id'] = null;
      op2(TopicModel.fromMap(newValue));
    }
    _write();
  }

  /// Helper method to check and delete appropriate topic from the list [topics].
  ///
  /// The method compares the set dates to identify the appropriate topic. As
  /// the set time is accurate upto the microsecond it is impossible for two
  /// topics to have the same creation time. If a match is found then [topic] is
  /// deleted from [topics].
  bool _deleteFromTopics(TopicModel topic) {
    DateTime createdDate = topic.creationDate;
    for (int i = 0; i < topics.length; ++i)
      if (topics[i].creationDate == createdDate) {
        topics.removeAt(i);
        return true;
      }
    return false;
  }

  /// Helper method to check and add topic to the list [topics].
  ///
  /// The method compares the set dates to identify appropriate topic. As
  /// the set time is accurate upto the microsecond it is impossible for two
  /// topics to have the same creation time. If a topic with the same set date
  /// exists in the list then [topic] isn't added.
  bool _addToTopic(TopicModel topic) {
    DateTime createdDate = topic.creationDate;
    bool found = false;

    for (int i = 0; i < topics.length; ++i)
      if (topics[i].creationDate == createdDate) {
        found = true;
        break;
      }

    if (found == false) topics.add(topic);

    return !found;
  }
}
