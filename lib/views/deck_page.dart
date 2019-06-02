import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/deck_database_bloc.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:flash_it/models/entities/topic_model.dart';
import 'package:flash_it/widgets/deck/deck_list.dart';
import 'package:flash_it/widgets/ui/form_dialog.dart';
import 'package:flutter/material.dart';

class DeckPage extends StatefulWidget {
  final Widget child;
  final TopicModel topic;

  DeckPage({Key key, @required this.topic, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  DeckDatabaseBloc _deckDatabaseBloc;

  @override
  Widget build(BuildContext context) {
    _deckDatabaseBloc = DeckDatabaseBloc(topicID: widget.topic.id);
    return BlocProvider<DeckDatabaseBloc>(
      key: Key("_DeckPageState BlocProvider"),
      bloc: _deckDatabaseBloc,
      child: Scaffold(
        key: Key("_DeckPageState Scaffold"),
        appBar: AppBar(
          key: Key("_DeckPageState AppBar"),
          title: Text('${widget.topic.name} Decks'),
          actions: <Widget>[
            IconButton(
              icon: Hero(tag: 'Add', child: Icon(Icons.add)),
              onPressed: () => _handleAdd(context),
            ),
          ],
        ),
        body: StreamBuilder<List<DeckModel>>(
          stream: _deckDatabaseBloc.decks,
          builder: _steamBuilder,
        ),
      ),
    );
  }

  Widget _steamBuilder(
    BuildContext context,
    AsyncSnapshot<List<DeckModel>> snapshot,
  ) =>
      snapshot.hasData
          ? snapshot.data.length > 0
              ? DeckList(
                  key: Key('_DeckPageState DeckList'),
                  decks: snapshot.data,
                )
              : Center(child: Text('${widget.topic.name} topic has no decks.'))
          : Center(
              child: CircularProgressIndicator(
              key: Key('_DeckPageState CircularProgressIndicator'),
            ));

  void _handleAdd(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => FormDialog(
            formData: Map<String, dynamic>.of(deckFormData),
            title: 'Add New Deck',
            field1: 1,
            field2: 2,
            fieldHint1: 'E.g. Calculus',
            fieldHint2: 'E.g. Facts and formulae',
            formKey1: deckAttributes[1][0],
            formKey2: deckAttributes[2][0],
            operation: _deckDatabaseBloc.insert,
            existingValue: null,
            primaryKey: deckPK,
            foreignKey: deckFK,
            parentID: widget.topic.id,
            buttonText: 'Add deck',
          ));
}
