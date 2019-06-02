import 'package:flutter/material.dart';

class QuizCardHeader extends StatelessWidget {
  final double width;
  final String question;

  QuizCardHeader({
    Key key,
    @required this.width,
    @required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 100,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Question', style: Theme.of(context).textTheme.subtitle),
            Text(
              question,
              style: Theme.of(context).textTheme.headline.copyWith(
                    color: Theme.of(context).primaryColorDark,
                  ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      );
}
