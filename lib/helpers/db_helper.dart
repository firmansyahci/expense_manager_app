import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'expenses.db'),
      onCreate: (db, version) async {
        return await _createDb(db);
      },
      version: 1,
    );
  }

  static Future<void> _createDb(Database db) async {
    try {
      await db.execute(
          'CREATE TABLE transactions (id INTEGER PRIMARY KEY, date TEXT, categoryId INTEGER, categoryName TEXT, amount INTEGER, description TEXT, type INTEGER)');
      await db.execute(
          'CREATE TABLE categories (id INTEGER PRIMARY KEY, name TEXT)');

      await db.insert('categories', {'name': 'Bonus'});
      await db.insert('transactions', {
        'date': '2021-10-15 08:57:47.812',
        'categoryId': 1,
        'categoryName': 'Bonus',
        'amount': 20000,
        'description': 'dari bos',
        'type': 0
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    final insertedId = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return insertedId;
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return await db.query(table);
  }

  static Future<void> delete(String table, int id) async {
    final db = await DBHelper.database();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(
      String table, Map<String, Object> data, int id) async {
    final db = await DBHelper.database();
    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }
}
