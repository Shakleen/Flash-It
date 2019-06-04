import 'dart:async';

import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/controllers/file_controller/topic_file.dart';
import 'package:flash_it/models/database/deck_database.dart';
import 'package:flash_it/models/database/topic_database.dart';
import 'package:flash_it/models/entities/topic_model.dart';

/// Class that implements bloc pattern for topic database.
///
/// The class creates the stream, sink, controller and transformer for the
/// topic bloc.
///
/// [_controller] is the StreamController for the topic bloc pattern.
/// [_transformer] transforms a list of maps to a list of object of type
/// [TopicModel].
class TopicDatabaseBloc implements BlocBase {
  final StreamController<List<Map<String, dynamic>>> _controller =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  final StreamTransformer<List<Map<String, dynamic>>, List<TopicModel>>
      _transformer = StreamTransformer<List<Map<String, dynamic>>,
          List<TopicModel>>.fromHandlers(handleData: _handleData);

  /// Constructor
  TopicDatabaseBloc() {
    getItems();
  }

  /// Returns the transformed contents present in the stream.
  Stream<List<TopicModel>> get topics =>
      _controller.stream.transform(_transformer);

  /// Method that adds content to the stream.
  ///
  /// Items are requested from the [TopicDatabase] which are added to the sink.
  void getItems() async =>
      _controller.sink.add(await TopicDatabase.topicDatabase.getItems());

  /// Method called on disposed. Used to close the stream controller
  /// [_controller].
  @override
  void dispose() {
    _controller.close();
  }

  /// Method to handle insertion of new topic.
  ///
  /// The method takes [input], processes it accordingly and passes it to the
  /// insert method in [TopicDatabase]. Afterwards on success of insertion
  /// the method also calls [TopicFile] to write the new topic to the topic.json
  /// file.
  Future<bool> insert(Map<String, dynamic> input) {
    input[topicAttributes[0][0]] = EditUserSettings.edit.settings.topics;
    input[topicAttributes[3][0]] = getCurrentDateAsString();
    input[topicAttributes[4][0]] = getCurrentDateAsString();
    return TopicDatabase.topicDatabase.insert(input).then((bool status) {
      if (status) {
        EditUserSettings.edit.incrementTopicCount();
        getItems();
        TopicFile.topicFile.add(input);
      }
      return status;
    });
  }

  /// Method to handle deletion of a topic.
  ///
  /// The method takes [input], processes it accordingly and passes it to the
  /// delete method in [TopicDatabase]. Afterwards on success of deletion
  /// the method also calls [TopicFile] to remove the topic from topic.json
  /// file.
  Future<bool> delete(dynamic item) {
    return TopicDatabase.topicDatabase.delete(item.toMap()).then((bool status) {
      if (status) {
        getItems();
        TopicFile.topicFile.remove(item.toMap());
      }
      return status;
    });
  }

  /// Method to handle update of an existing topic.
  ///
  /// The method takes [input] and previous value [old], processes it
  /// accordingly and passes it to the update method in [TopicDatabase].
  /// Afterwards on success of update the method also calls [TopicFile] to
  /// update the topic in topic.json file.
  Future<bool> update(Map<String, dynamic> input, Map<String, dynamic> old) {
    input[topicAttributes[3][0]] = getCurrentDateAsString();
    input[topicAttributes[4][0]] = getCurrentDateAsString();
    return TopicDatabase.topicDatabase.update(input).then((bool status) {
      if (status) {
        getItems();
        TopicFile.topicFile.update(old, input);
      }
      return status;
    });
  }

  /// Method to get the total topics in [TopicDatabase].
  Future<int> getTotal() => TopicDatabase.topicDatabase.getItemCount();

  /// Method to get the total number of decks in [DeckDatabase] under [topicID]
  Future<int> getTotalDecks(int topicID) =>
      DeckDatabase.deckDatabase.getItemCount(topicID: topicID);

  /// Helper method to handle the manipulation of data during transformation.
  ///
  /// The method basically takes as input a list of maps. It constructs from
  /// map a [TopicModel] object.
  static void _handleData(
    List<Map<String, dynamic>> data,
    EventSink<List<TopicModel>> sink,
  ) {
    final List<TopicModel> topics = [];
    if (data != null)
      for (Map<String, dynamic> element in data)
        topics.add(TopicModel.fromMap(element));

    sink.add(topics);
  }
}
