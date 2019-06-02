import 'package:flutter/material.dart';

class AlertOperation extends StatelessWidget {
  final String title, content, buttonText;
  final Color mainColor;

  AlertOperation({
    Key key,
    @required this.title,
    @required this.content,
    @required this.buttonText,
    @required this.mainColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.title),
      content: Text(content, style: Theme.of(context).textTheme.body1),
      actions: <Widget>[
        RaisedButton(
          child: Text('Got It!', style: Theme.of(context).textTheme.body2),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}

void showAlertOperation({
  @required BuildContext context,
  @required String title,
  @required String content,
  @required String buttonText,
  @required Color mainColor,
}) =>
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertOperation(
              content: content,
              title: title,
              buttonText: buttonText,
              mainColor: mainColor,
            ));
