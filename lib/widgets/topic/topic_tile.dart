import 'dart:async';

import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/topic_database_bloc.dart';
import 'package:flash_it/models/entities/topic_model.dart';
import 'package:flash_it/views/deck_page.dart';
import 'package:flash_it/widgets/ui/confirm_delete_dialog.dart';
import 'package:flash_it/widgets/ui/dismissible_container.dart';
import 'package:flash_it/widgets/ui/form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopicTile extends StatefulWidget {
  final TopicModel topic;
  final Widget child;
  final bool isOdd;

  TopicTile({
    Key key,
    @required this.topic,
    @required this.isOdd,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  TopicDatabaseBloc _topicDatabaseBloc;
  Timer _loadDecksTimer;

  @override
  void dispose() {
    if (_loadDecksTimer != null) _loadDecksTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat _dateFormatter = DateFormat("dd/MM/yyyy");
    _topicDatabaseBloc = BlocProvider.of<TopicDatabaseBloc>(context);

    MainAxisAlignment alignment = MainAxisAlignment.end;
    DismissDirection direction = DismissDirection.endToStart;

    if (widget.isOdd) {
      alignment = MainAxisAlignment.start;
      direction = DismissDirection.startToEnd;
    }

    return FutureBuilder<int>(
      future: _topicDatabaseBloc.getTotalDecks(widget.topic.id),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        int deckNumber = 0;
        if (snapshot.hasData) deckNumber = snapshot.data;
        return Dismissible(
          key: Key('TopicTile Dismissible'),
          direction: direction,
          confirmDismiss: _handleConfirmDismiss,
          onDismissed: _handleOnDismissed,
          background: DismissibleContainer(
            color: Theme.of(context).errorColor,
            icon: Icons.delete,
            mainAxisAlignment: alignment,
          ),
          dismissThresholds: {direction: 0.9},
          child: Card(
            elevation: 1,
            child: InkWell(
              key: Key('${this.runtimeType} InkWell'),
              child: Center(
                child: ListTile(
                  title: Text(
                    widget.topic.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.topic.description),
                      Text('Decks: $deckNumber'),
                      Text(
                        'Created: ${_dateFormatter.format(widget.topic.creationDate)}',
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => _handleTopicTap(context),
              onLongPress: () => _handleTopicLongPress(context),
              splashColor: Theme.of(context).accentColor,
            ),
          ),
        );
      },
    );
  }

  void _handleTopicLongPress(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => FormDialog(
              formData: Map<String, dynamic>.of(topicFormData),
              title: 'Edit Topic Details',
              field1: 1,
              field2: 2,
              fieldHint1: 'E.g. Math',
              fieldHint2: 'E.g. Formulae',
              formKey1: topicAttributes[1][0],
              formKey2: topicAttributes[2][0],
              operation: _topicDatabaseBloc.update,
              existingValue: widget.topic,
              primaryKey: topicPK,
              foreignKey: null,
              parentID: null,
              buttonText: 'Edit topic',
            ));
  }

  Future<bool> _handleConfirmDismiss(DismissDirection direction) async {
    final DeleteDialog dialog =
        DeleteDialog(decision: Future.value(false), content: 'topic');

    await showDialog(
        context: context, builder: (BuildContext context) => dialog);

    Future<bool> decision = dialog.decision;

    return decision;
  }

  void _handleOnDismissed(DismissDirection direction) =>
      _topicDatabaseBloc.delete(widget.topic);

  void _handleTopicTap(BuildContext context) {
    if (_loadDecksTimer == null || _loadDecksTimer.isActive == false) {
      _loadDecksTimer = Timer(
          const Duration(milliseconds: 200),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    DeckPage(topic: widget.topic),
              )));
    }
  }
}
