import 'package:flutter/material.dart';

class DismissibleContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final MainAxisAlignment mainAxisAlignment;

  DismissibleContainer({
    Key key,
    @required this.color,
    @required this.icon,
    @required this.mainAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: Row(
          children: <Widget>[Icon(icon, size: 35.0, color: Colors.white)],
          mainAxisAlignment: mainAxisAlignment,
        ),
        padding: EdgeInsets.symmetric(horizontal: 25.0),
      );
}
