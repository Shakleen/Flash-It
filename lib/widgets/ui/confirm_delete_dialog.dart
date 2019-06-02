import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  Future<bool> decision;
  final Widget child;
  final String content;

  DeleteDialog({
    Key key,
    @required this.decision,
    @required this.content,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          'Confirm delete',
          style: Theme.of(context).textTheme.title.copyWith(
                color: Theme.of(context).errorColor,
              ),
        ),
        content: Text('Are you sure you want to delete this $content?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          RaisedButton(
            onPressed: () {
              decision = Future.value(true);
              Navigator.pop(context);
            },
            child: Text('Delete', style: Theme.of(context).textTheme.body2),
            color: Theme.of(context).errorColor,
          ),
        ],
      );
}
