import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/card_database_bloc.dart';
import 'package:flash_it/models/entities/card_model.dart';
import 'package:flash_it/presentation/custom_icons_icons.dart';
import 'package:flash_it/widgets/ui/confirm_delete_dialog.dart';
import 'package:flash_it/widgets/ui/dismissible_container.dart';
import 'package:flash_it/widgets/ui/form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardTile extends StatelessWidget {
  final CardModel cardModel;
  CardDatabaseBloc _cardDatabaseBloc;

  CardTile({Key key, @required this.cardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _cardDatabaseBloc = BlocProvider.of<CardDatabaseBloc>(context);
    final DateFormat _dateFormatter = DateFormat("dd/MM/yyyy");
    return Dismissible(
      key: Key('CardTile Dismissible'),
      direction: DismissDirection.endToStart,
      background: DismissibleContainer(
        color: Theme.of(context).errorColor,
        icon: Icons.delete,
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      dismissThresholds: {DismissDirection.endToStart: 0.9},
      onDismissed: _onDismissed,
      confirmDismiss: (DismissDirection direction) => _confirmDismiss(
            context: context,
            direction: DismissDirection.endToStart,
          ),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          style: BorderStyle.solid,
          width: 0.25,
          color: Colors.black,
        ))),
        child: ListTile(
          title: Text(cardModel.question),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Answer: ${cardModel.answer}'),
              Text(
                  'Next quiz: ${_dateFormatter.format(cardModel.nextQuizDate)}'),
              Text('Current streak: ${cardModel.memoryState}'),
            ],
          ),
          isThreeLine: true,
          trailing: IconButton(
            icon: Icon(
              cardModel.important
                  ? CustomIcons.diamond
                  : CustomIcons.diamond_border,
              color: Theme.of(context).errorColor,
            ),
            onPressed: _handleFavorite,
            tooltip: 'Mark important',
          ),
          onLongPress: () => _handleLongPress(context),
        ),
      ),
    );
  }

  void _handleFavorite() => _cardDatabaseBloc.markImportant(cardModel);

  void _handleLongPress(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => FormDialog(
            formData: Map<String, dynamic>.of(cardFormData),
            title: 'Edit Card Details',
            field1: 2,
            field2: 3,
            fieldHint1: 'E.g. Tranquility',
            fieldHint2: 'E.g. Silence',
            formKey1: cardAttributes[2][0],
            formKey2: cardAttributes[3][0],
            operation: _cardDatabaseBloc.update,
            existingValue: cardModel,
            primaryKey: cardPK,
            foreignKey: cardFK,
            parentID: cardModel.deckID,
            buttonText: 'Edit card',
          ));

  void _onDismissed(DismissDirection direction) =>
      _cardDatabaseBloc.delete(cardModel);

  Future<bool> _confirmDismiss(
      {DismissDirection direction, BuildContext context}) async {
    final DeleteDialog dialog =
        DeleteDialog(decision: Future.value(false), content: 'card');

    await showDialog(
        context: context, builder: (BuildContext context) => dialog);

    Future<bool> decision = dialog.decision;

    return decision;
  }
}
