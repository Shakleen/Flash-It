import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/widgets/settings/card_no_slider.dart';
import 'package:flash_it/widgets/ui/side_drawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function changeTheme;
  final List<Color> themes = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  SettingsPage({Key key, @required this.changeTheme}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _applied;

  @override
  void initState() {
    _applied = EditUserSettings.edit.settings.appThemeColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(1),
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          ListTile(
            title: Container(
              child: Text(
                'Theme color',
                style: Theme.of(context).textTheme.title,
              ),
              alignment: Alignment.topCenter,
            ),
            subtitle: ButtonBar(
              mainAxisSize: MainAxisSize.min,
              alignment: MainAxisAlignment.spaceEvenly,
              children: _populateThemeColor(),
            ),
          ),
          Divider(color: Colors.black),
          CardNoSlider(),
          Divider(color: Colors.black),
          ListTile(
            title: Container(
              child: Text(
                'Daily notification time',
                style: Theme.of(context).textTheme.title,
              ),
              alignment: Alignment.topCenter,
            ),
          ),
          Divider(color: Colors.black),
          ListTile(
            title: Container(
              child: Text(
                'Daily sync time',
                style: Theme.of(context).textTheme.title,
              ),
              alignment: Alignment.topCenter,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _populateThemeColor() {
    final List<Widget> _themeColors = [];
    for (int i = 0; i < widget.themes.length; ++i)
      _themeColors.add(CircleAvatar(
        backgroundColor: widget.themes[i],
        child: i == _applied
            ? IconButton(
                icon: Icon(Icons.done),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: null,
              )
            : IconButton(
                icon: Icon(Icons.details),
                color: Colors.white,
                splashColor: widget.themes[i],
                highlightColor: widget.themes[i],
                onPressed: () => _handleColorChange(i),
              ),
      ));
    return _themeColors;
  }

  void _handleColorChange(int i) {
    setState(() {
      EditUserSettings.edit.modifyThemeColor(i);
      _applied = i;
      widget.changeTheme();
    });
  }
}
