import 'package:sqflite/sqflite.dart';

abstract class BaseDatabase {
  Database database;
  String tableName, primaryKey;
  Map<int, List<String>> attributes;

  Future<bool> initDatabase();

  Future<bool> insert(Map<String, dynamic> item);

  Future<bool> delete(Map<String, dynamic> item);

  Future<bool> update(Map<String, dynamic> item);

  Future<dynamic> getItems();

  Future<int> getItemCount();
}
