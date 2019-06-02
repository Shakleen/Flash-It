import 'dart:async';

import 'package:flutter/material.dart';

class QuizCardTrailer extends StatefulWidget {
  final double height, width;
  final String answer;

  QuizCardTrailer({
    Key key,
    @required this.height,
    @required this.width,
    @required this.answer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizCardTrailerState();
}

class _QuizCardTrailerState extends State<QuizCardTrailer> {
  bool _revealed = false;
  Timer _showAnswer;

  @override
  void initState() {
    _revealed = false;
    super.initState();
  }

  @override
  void dispose() {
    if (_showAnswer != null) _showAnswer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height - 150,
      width: widget.width,
      child: _revealed
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  QuizCardAnswer(answer: widget.answer),
                  SwipeIndicator(),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: widget.width,
                  padding: const EdgeInsets.all(25),
                  child: IconButton(
                    icon: Icon(
                      Icons.slideshow,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                    splashColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    tooltip: "Show Answer",
                    onPressed: _handleReveal,
                  ),
                )
              ],
            ),
    );
  }

  void _handleReveal() {
    if (_showAnswer == null) {
      _showAnswer = Timer(const Duration(milliseconds: 300), _reveal);
    }
  }

  void _reveal() => setState(() => _revealed = true);
}

class SwipeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Swipe to dismiss', style: Theme.of(context).textTheme.subtitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                padding: const EdgeInsets.all(0),
                child: Text('<<< Wrong',
                    style: Theme.of(context).textTheme.body2.copyWith(
                          color: Colors.red,
                        )),
                onPressed: null,
              ),
              FlatButton(
                padding: const EdgeInsets.all(0),
                child: Text('Correct >>>',
                    style: Theme.of(context).textTheme.body2.copyWith(
                          color: Colors.green,
                        )),
                onPressed: null,
              ),
            ],
          )
        ],
      );
}

class QuizCardAnswer extends StatelessWidget {
  final String answer;

  QuizCardAnswer({Key key, @required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Answer', style: Theme.of(context).textTheme.subtitle),
          Text(
            answer,
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ],
      );
}
