import 'dart:io';

import 'package:flash_it/models/database/base_database.dart';
import 'package:flash_it/models/entities/deck_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DeckDatabase implements BaseDatabase {
  static final DeckDatabase deckDatabase = DeckDatabase._();
  int topicID;

  DeckDatabase._() {
    topicID = 0;
    attributes = deckAttributes;
    tableName = deckTable;
    primaryKey = deckPK;
  }

  @override
  Database database;

  @override
  Map<int, List<String>> attributes;

  @override
  String tableName;

  @override
  String primaryKey;

  @override
  Future<bool> initDatabase() async {
    database == null ? await _createDatabase() : null;
    return Future.value(database != null);
  }

  @override
  Future<bool> insert(Map<String, dynamic> item) async {
//    final String debug = '${this.runtimeType} insert'; // TODO DEBUG
    bool status = false;
    item.remove(primaryKey);

    try {
      await database.insert(tableName, item);
      status = true;
    } catch (e) {
//      print('$debug $e'); // TODO DEBUG
    }

//    print('$debug insertion status: $status'); // TODO DEBUG
    return status;
  }

  @override
  Future<bool> delete(Map<String, dynamic> item) async {
//    final String debug = '${this.runtimeType} delete'; // TODO DEBUG
    int result = 0;

    try {
      result = await database.delete(tableName,
          where: '$primaryKey = ${item[primaryKey]}');
    } catch (e) {
//      print('$debug $e'); // TODO DEBUG
    }

//    print('$debug deletion status: ${result > 0}'); // TODO DEBUG
    return result > 0;
  }

  @override
  Future<bool> update(Map<String, dynamic> item) async {
//    final String debug = '${this.runtimeType} update'; // TODO DEBUG
    bool status = false;
    final dynamic value = item[primaryKey];
    item.remove(primaryKey);
    item.remove(deckFK);
    item.remove(attributes[3][0]);
    item.remove(attributes[4][0]);

//    print('$debug update - the map for $value is $item'); // TODO DEBUG

    try {
      final int result = await database.update(tableName, item,
          where: "$primaryKey = ?", whereArgs: [value]);
//      print('$debug result is $result'); // TODO DEBUG
      status = result != 0;
    } catch (e) {
//      print('$debug $e'); // TODO DEBUG
    }

//    print('$debug update status: $status'); // TODO DEBUG
    return status;
  }

  @override
  Future<dynamic> getItems() async {
//    final String debug = '${this.runtimeType} getItems'; // TODO DEBUG
    List<Map<String, dynamic>> result = [];

    try {
      result = await database.query(tableName, where: '$deckFK = $topicID');
    } catch (e) {
//      print('$debug $e'); // TODO DEBUG
    }

//    print('$debug Result is ${result.length}'); // TODO DEBUG
    return result;
  }

  @override
  Future<int> getItemCount({int topicID}) async {
//    final String debug = '${this.runtimeType} getItemCount'; // TODO DEBUG
    List<Map<String, dynamic>> result = [];
    String sql = "SELECT COUNT($primaryKey) FROM $tableName";

    if (topicID != null) sql += " WHERE $deckFK = $topicID";

    try {
      result = await database.rawQuery(sql);
    } catch (e) {
//      print('$debug $e'); // TODO DEBUG
    }

    final int databaseSize = result[0]['COUNT($primaryKey)'];
//    print('$debug database size is $databaseSize'); // TODO DEBUG
    return databaseSize;
  }

  void _handleOnCreate(Database db, int version) async {
//    final String debug = '${this.runtimeType} _handleOnCreate'; // TODO DEBUG
    final int numberOfColumns = attributes.length - 1;
    String sql = "CREATE TABLE $tableName (";

    // Creating the column name and column type portion
    for (int i = 0; i <= numberOfColumns; ++i)
      sql += "${attributes[i][0]} " +
          "${attributes[i][1]} " +
          "${attributes[i][2]}" +
          (i < numberOfColumns ? ", " : ", $deckFKTable)");

//    print('$debug $sql'); // TODO DEBUG

    await db.execute(sql);
  }

  Future<void> _createDatabase() async {
//    final String debug = '${this.runtimeType} _createDatabase'; // TODO DEBUG

    // Get directory and file path
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, tableName);

    // Open database file and create a table if it doesn't exist.
    database = await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _handleOnCreate);

//    if (database != null)
//      print('$debug Database successfully created!'); // TODO DEBUG
//    else
//      print('$debug Database creation failed!'); // TODO DEBUG
  }
}
