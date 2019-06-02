import 'dart:async';

import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/deck_database_bloc.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:flash_it/views/card_page.dart';
import 'package:flash_it/views/quiz_page.dart';
import 'package:flash_it/widgets/ui/confirm_delete_dialog.dart';
import 'package:flash_it/widgets/ui/dismissible_container.dart';
import 'package:flash_it/widgets/ui/form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeckTile extends StatefulWidget {
  final Widget child;
  final DeckModel deck;

  DeckTile({Key key, @required this.deck, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeckTileState();
}

class _DeckTileState extends State<DeckTile> {
  DeckDatabaseBloc _deckDatabaseBloc;
  Timer _loadQuizCards;

  @override
  void dispose() {
    if (_loadQuizCards != null) _loadQuizCards.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat _dateFormatter = DateFormat("dd/MM/yyyy");
    final String create = _dateFormatter.format(widget.deck.creationDate);
    final String lastViewed = _dateFormatter.format(widget.deck.lastViewedDate);
    final String name = widget.deck.name;
    final String description = widget.deck.description;
    _deckDatabaseBloc = BlocProvider.of<DeckDatabaseBloc>(context);

    return FutureBuilder<int>(
      future: _deckDatabaseBloc.getCardsNumber(widget.deck.id),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        int cardsInDeck = 0;

        if (snapshot.hasData) cardsInDeck = snapshot.data;

        return Dismissible(
          key: Key('${this.runtimeType} Dissmissible'),
          direction: DismissDirection.endToStart,
          dismissThresholds: {DismissDirection.endToStart: 0.9},
          background: DismissibleContainer(
            mainAxisAlignment: MainAxisAlignment.end,
            icon: Icons.delete,
            color: Theme.of(context).errorColor,
          ),
          onDismissed: _handleDismissed,
          confirmDismiss: _confirmDismissed,
          child: Card(
            elevation: 1,
            child: InkWell(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(name, style: Theme.of(context).textTheme.title),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(description,
                          style: Theme.of(context).textTheme.subtitle),
                      Text('Created: $create'),
                      Text('Last Viewed: $lastViewed'),
                      Text('Cards in deck: $cardsInDeck')
                    ],
                  ),
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: _handleEdit,
                ),
                contentPadding: const EdgeInsets.all(5),
              ),
              onTap: _handleOnTap,
              onLongPress: _handleOnLongPress,
              splashColor: Theme.of(context).accentColor,
            ),
          ),
        );
      },
    );
  }

  void _handleOnTap() {
    if (_loadQuizCards == null || _loadQuizCards.isActive == false) {
      _deckDatabaseBloc.updateLastViewed(widget.deck);
      _loadQuizCards = Timer(
          const Duration(milliseconds: 300),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      QuizPage(deck: widget.deck))));
    }
  }

  void _handleDismissed(DismissDirection direction) =>
      _deckDatabaseBloc.delete(widget.deck);

  Future<bool> _confirmDismissed(DismissDirection direction) async {
    final DeleteDialog dialog =
        DeleteDialog(decision: Future.value(false), content: 'deck');

    await showDialog(
        context: context, builder: (BuildContext context) => dialog);

    Future<bool> decision = dialog.decision;

    return decision;
  }

  void _handleOnLongPress() => showDialog(
      context: context,
      builder: (BuildContext context) => FormDialog(
            formData: Map<String, dynamic>.of(deckFormData),
            title: 'Edit Deck Details',
            field1: 1,
            field2: 2,
            fieldHint1: 'E.g. Calculus',
            fieldHint2: 'E.g. Facts and formulae',
            formKey1: deckAttributes[1][0],
            formKey2: deckAttributes[2][0],
            operation: _deckDatabaseBloc.update,
            existingValue: widget.deck,
            primaryKey: deckPK,
            foreignKey: deckFK,
            parentID: null,
            buttonText: 'Edit deck',
          ));

  void _handleEdit() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => CardPage(deck: widget.deck)));
}
