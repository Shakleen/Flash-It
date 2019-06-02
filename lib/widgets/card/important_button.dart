import 'package:flash_it/presentation/custom_icons_icons.dart';
import 'package:flutter/material.dart';

class ImportantButton extends StatefulWidget {
  final bool initStatus;
  final Function markImportant;

  ImportantButton({
    Key key,
    @required this.initStatus,
    @required this.markImportant,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImportantButtonState();
}

class _ImportantButtonState extends State<ImportantButton> {
  bool _important;

  @override
  void initState() {
    _important = widget.initStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(
          _important ? CustomIcons.diamond : CustomIcons.diamond_border,
          color: Theme.of(context).errorColor,
        ),
        splashColor: Theme.of(context).errorColor,
        highlightColor: Theme.of(context).errorColor,
        onPressed: _markImportant,
        tooltip: 'Mark ${_important ? 'important' : 'unimportant'}',
      ),
    );
  }

  void _markImportant() {
    setState(() {
      _important = !_important;
      widget.markImportant();
    });
  }
}
