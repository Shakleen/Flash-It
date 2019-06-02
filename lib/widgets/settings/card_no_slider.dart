import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flutter/material.dart';

class CardNoSlider extends StatefulWidget {
  CardNoSlider({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardNoSliderState();
}

class _CardNoSliderState extends State<CardNoSlider> {
  double _value;

  @override
  void initState() {
    _value = EditUserSettings.edit.settings.cardsPerQuiz * 1.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Container(
          child: Text(
            '${_value.toInt()} cards per quiz',
            style: Theme.of(context).textTheme.title,
          ),
          alignment: Alignment.topCenter,
        ),
        subtitle: Slider(
          min: 10,
          max: 25,
          divisions: 15,
          value: _value,
          activeColor: Theme.of(context).primaryColor,
          label: '${_value.toInt()}',
          onChanged: _handleSliderValueChange,
          onChangeEnd: _saveChange,
        ),
      );

  void _handleSliderValueChange(double value) {
    setState(() {
      _value = value.round().toDouble();
    });
  }

  void _saveChange(double value) =>
      EditUserSettings.edit.modifyCardsPerQuiz(_value.toInt());
}
