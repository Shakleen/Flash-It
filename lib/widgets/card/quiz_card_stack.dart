import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/card_database_bloc.dart';
import 'package:flash_it/models/entities/card_model.dart';
import 'package:flash_it/widgets/card/quiz_card.dart';
import 'package:flutter/material.dart';

class QuizCardStack extends StatefulWidget {
  final List<CardModel> quizCards;
  final void Function() setFinished;

  QuizCardStack({
    Key key,
    @required this.quizCards,
    @required this.setFinished,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizCardStackState();
}

class _QuizCardStackState extends State<QuizCardStack> {
  CardDatabaseBloc _cardDatabaseBloc;
  double _horizontal, _bottom;
  List<CardModel> _quizCards;

  @override
  void initState() {
    _quizCards = widget.quizCards;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cardDatabaseBloc = BlocProvider.of<CardDatabaseBloc>(context);
    _horizontal = MediaQuery.of(context).size.width * 0.05;
    _bottom = MediaQuery.of(context).size.height * 0.1;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: _quizCards.map((CardModel card) {
        final int index = _quizCards.indexOf(card),
            offset = _quizCards.length - index;
        final double bottom = (_bottom + index * 4.0),
            left = (_horizontal + offset),
            right = (_horizontal + offset);
        final bool last2 = (index >= _quizCards.length - 2);

        return Positioned(
            bottom: bottom < 200.0 ? bottom : 200.0,
            left: left < 50 ? left : 50,
            right: right < 50 ? right : 50,
            child: Dismissible(
              key: ValueKey(card.cardID),
              direction: index == _quizCards.length - 1
                  ? DismissDirection.horizontal
                  : null,
              onDismissed: (DismissDirection direction) =>
                  _handleOnDismissed(direction, card),
              child: QuizCard(
                cardWidth: _horizontal,
                cardModel: last2 ? card : null,
                mode: last2,
              ),
            ));
      }).toList(),
    );
  }

  void _handleOnDismissed(DismissDirection direction, CardModel card) {
    if (_quizCards.indexOf(card) == _quizCards.length - 1) {
      setState(() {
        if (direction == DismissDirection.endToStart)
          _cardDatabaseBloc.guessedWrong(card);
        else
          _cardDatabaseBloc.guessedCorrect(card);
        _quizCards.remove(card);
        if (_quizCards.isEmpty) widget.setFinished();
      });
    }
  }
}
