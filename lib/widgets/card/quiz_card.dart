import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/card_database_bloc.dart';
import 'package:flash_it/models/entities/card_model.dart';
import 'package:flash_it/widgets/card/important_button.dart';
import 'package:flash_it/widgets/card/quiz_card_header.dart';
import 'package:flash_it/widgets/card/quiz_card_trailer.dart';
import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final CardModel cardModel;
  final double cardWidth;
  final bool mode;

  QuizCard({
    Key key,
    @required this.mode,
    @required this.cardModel,
    @required this.cardWidth,
  }) : super(key: key);

  double _width, _height;
  CardDatabaseBloc _cardDatabaseBloc;

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    _cardDatabaseBloc = BlocProvider.of<CardDatabaseBloc>(context);
    _height = MediaQuery.of(context).size.height * 0.5;
    _width = MediaQuery.of(context).size.width * 0.8 + cardWidth;

    if (mode) {
      child = Column(
        children: <Widget>[
          ImportantButton(
            initStatus: cardModel?.important,
            markImportant: _markImportant,
          ),
          QuizCardHeader(width: _width, question: cardModel.question),
          QuizCardTrailer(
            width: _width,
            height: _height,
            answer: cardModel.answer,
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.25,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 0.5,
            offset: Offset(0.5, 0.5),
            spreadRadius: 0.5,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: _height + 10,
      width: _width,
      child: Card(child: child, elevation: 0),
    );
  }

  void _markImportant() => _cardDatabaseBloc.markImportant(cardModel);
}
