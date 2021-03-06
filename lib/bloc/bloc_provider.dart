import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();

  Future<bool> insert(Map<String, dynamic> input);

  Future<bool> update(Map<String, dynamic> input, Map<String, dynamic> old);

  Future<bool> delete(dynamic item);

  Future<int> getTotal();

  void getItems();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({Key key, @required this.child, @required this.bloc})
      : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

String getCurrentDateAsString() {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day).toString();
}