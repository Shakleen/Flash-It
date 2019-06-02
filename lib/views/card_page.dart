import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/card_database_bloc.dart';
import 'package:flash_it/models/entities/card_model.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:flash_it/presentation/custom_icons_icons.dart';
import 'package:flash_it/widgets/card/card_tile.dart';
import 'package:flash_it/widgets/ui/form_dialog.dart';
import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  final Widget child;
  final DeckModel deck;

  CardPage({Key key, @required this.deck, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  CardDatabaseBloc _cardDatabaseBloc;
  bool _filterImportant;

  @override
  void initState() {
    _filterImportant = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cardDatabaseBloc = CardDatabaseBloc(deckID: widget.deck.id);

    return BlocProvider<CardDatabaseBloc>(
      key: Key("_CardPageState BlocProvider"),
      bloc: _cardDatabaseBloc,
      child: StreamBuilder<List<CardModel>>(
        stream: _cardDatabaseBloc.cards,
        builder: _steamBuilder,
      ),
    );
  }

  Widget _steamBuilder(
      BuildContext context, AsyncSnapshot<List<CardModel>> snapshot) {
    final Widget body = snapshot.hasData
        ? snapshot.data.isNotEmpty
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    CardTile(cardModel: snapshot.data[index]),
              )
            : Center(child: Text("Empty deck. Add some cards."))
        : Center(child: CircularProgressIndicator());

    return Scaffold(
      key: Key("_CardPageState Scaffold"),
      appBar: AppBar(
        key: Key("_CardPageState AppBar"),
        title: Text('${widget.deck.name} Cards'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _filterImportant
                  ? CustomIcons.diamond
                  : CustomIcons.diamond_border,
            ),
            onPressed: _handleImportantToggle,
            tooltip: 'Show ${_filterImportant ? 'all' : 'important'}',
          ),
          IconButton(
            icon: Hero(tag: 'Add', child: Icon(Icons.add)),
            onPressed: _handleAdd,
            tooltip: 'Add new card',
          ),
        ],
      ),
      body: body,
    );
  }

  void _handleAdd() => showDialog(
      context: context,
      builder: (BuildContext context) => FormDialog(
            formData: Map<String, dynamic>.of(cardFormData),
            title: 'Add New Card',
            field1: 2,
            field2: 3,
            fieldHint1: 'E.g. Tranquility',
            fieldHint2: 'E.g. Silence',
            formKey1: cardAttributes[2][0],
            formKey2: cardAttributes[3][0],
            operation: _cardDatabaseBloc.insert,
            existingValue: null,
            primaryKey: cardPK,
            foreignKey: cardFK,
            parentID: widget.deck.id,
            buttonText: 'Add card',
          ));

  void _handleImportantToggle() {
    _filterImportant = !_filterImportant;
    _cardDatabaseBloc.toggleImportant();
  }
}
