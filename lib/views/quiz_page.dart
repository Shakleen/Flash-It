import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/card_database_bloc.dart';
import 'package:flash_it/models/entities/card_model.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:flash_it/widgets/card/quiz_card_stack.dart';
import 'package:flash_it/widgets/ui/quit_dialog.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final Widget child;
  final DeckModel deck;

  QuizPage({Key key, @required this.deck, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  CardDatabaseBloc _cardDatabaseBloc;
  bool _finished;
  List<CardModel> _quizCards;

  @override
  void initState() {
    _finished = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cardDatabaseBloc = CardDatabaseBloc(deckID: widget.deck.id);
    return WillPopScope(
      child: BlocProvider<CardDatabaseBloc>(
        bloc: _cardDatabaseBloc,
        child: Scaffold(
          appBar: AppBar(title: Text('${widget.deck.name} quiz')),
          body: StreamBuilder<List<CardModel>>(
            stream: _cardDatabaseBloc.quizCards,
            builder: _streamBuilder,
          ),
        ),
      ),
      onWillPop: _handleOnWillPop,
    );
  }

  Widget _streamBuilder(
      BuildContext context, AsyncSnapshot<List<CardModel>> snapshot) {
    if (snapshot.hasData == false)
      return Center(child: CircularProgressIndicator());

    if (snapshot.data.isEmpty) {
      _finished = true;
      return Center(child: Text('No cards to quiz!'));
    }

    _quizCards = snapshot.data;
    return Container(
      alignment: Alignment.center,
      child: QuizCardStack(quizCards: snapshot.data, setFinished: _setFinished),
    );
  }

  void _setFinished() => _finished = true;

  void _resetRemainingCardStreak() {
    for (CardModel card in _quizCards)
      if (card.nextQuizDate.isBefore(DateTime.now()))
        _cardDatabaseBloc.guessedWrong(card);
  }

  Future<bool> _handleOnWillPop() async {
    if (_finished) return Future.value(true);
    final QuitDialog quitDialog = QuitDialog(
      title: 'Confirm quit',
      content:
          'Cards left in quiz! Exiting now will reset their memory streak. Do you still want to quit?',
      raisedButtonText: 'Quit quiz',
      reset: _resetRemainingCardStreak,
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) => quitDialog,
    );
    return Future.value(quitDialog.result);
  }
}
