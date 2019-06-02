import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  final String buttonText;

  LogInButton({Key key, @required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 320,
        height: 60,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(const Radius.circular(30.0)),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
          ),
        ),
      );
}
