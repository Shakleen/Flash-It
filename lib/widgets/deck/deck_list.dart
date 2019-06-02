import 'package:flash_it/models/entities/deck_model.dart';
import 'package:flash_it/widgets/deck/deck_tile.dart';
import 'package:flutter/material.dart';

class DeckList extends StatelessWidget {
  final Widget child;
  final List<DeckModel> decks;

  DeckList({Key key, @required this.decks, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scrollbar(
        key: Key('${this.runtimeType} Scrollbar'),
        child: ListView.builder(
          key: Key("${this.runtimeType} ListView.builder"),
          itemCount: decks.length,
          itemBuilder: (BuildContext context, int index) =>
              DeckTile(key: ValueKey(decks[index].id), deck: decks[index]),
        ),
      );
}
