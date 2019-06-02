import 'package:flutter/material.dart';

class QuitDialog extends StatelessWidget {
  final String title, content, raisedButtonText;
  final Function reset;
  bool result;

  QuitDialog({
    Key key,
    this.result,
    this.reset,
    @required this.title,
    @required this.content,
    @required this.raisedButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.title.copyWith(
                color: Theme.of(context).errorColor,
              ),
        ),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('Go back'),
            onPressed: () {
              result = false;
              Navigator.pop(context);
            },
          ),
          RaisedButton(
            child: Text(
              raisedButtonText,
              style: Theme.of(context).textTheme.body2,
            ),
            color: Theme.of(context).errorColor,
            onPressed: () {
              if (reset != null) reset();
              result = true;
              Navigator.pop(context);
            },
          ),
        ],
      );
}
