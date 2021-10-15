import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart';

class SQLiteDatabase implements DatabaseHelper {
  SQLiteDatabase._();

  final String databaseName = 'data.db';
  final int version = 1;
  static final SQLiteDatabase instance = SQLiteDatabase._();
  Database? _database;

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _createDatabase();
    return _database!;
  }

  Future<Database> _createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(
      path,
      version: version,
    );
  }

  @override
  Future<void> init(String table, Map<String, Map<Type, bool>> fields) async {
    final db = await database;
    String sql = 'CREATE TABLE IF NOT EXISTS $table (';
    for (var entity in fields.entries) {
      String key = entity.key;
      String nullable = entity.value.values.first ? 'NULL' : '';
      String type = '';
      switch (entity.value.keys.first) {
        case int:
          type = 'INTEGER';
          break;
        case String:
          type = 'TEXT';
          break;
        case double:
          type = 'REAL';
          break;
      }
      if (entity.key == fields.entries.first.key){
        type += ' PRIMARY KEY';
      }
      sql += '$key $type $nullable,';
    }
    sql = sql.substring(0, sql.length - 1) + ')';
    await db.execute(sql);
  }

  @override
  Future<void> dropTable(
      String table, Map<String, Map<Type, bool>> fields) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $table;');
    await init(table, fields);
  }

  @override
  Future<Map<String, dynamic>> getNote(
      String table, Map<String, Object> params) async {
    final db = await database;
    var data = await db.query(table,
        where: '${params.keys.first} = ?', whereArgs: [params.values.first]);
    return data.first;
  }

  @override
  Future<List<Map<String, dynamic>>> getNotes(String table) async {
    final db = await database;
    return await db.query(table);
  }

  @override
  Future<Map<String, Object?>> addNote(String table, Map<String, Object?> map) async {
    final db = await database;
    await db.insert(table, map);
    var lst = await db.query(table);
    return lst.last;
  }

  @override
  Future<void> addNotes(String table, List<Map<String, Object?>> lst) async {
    final db = await database;
    await db.transaction((txn) async {
      for (Map<String, Object?> map in lst) {
        // maybe I don't need to await
        await txn.insert(table, map);
      }
    });
  }

  @override
  Future<void> updateNote(String table, Map<String, Object?> map,
      Map<String, Object> params) async {
    final db = await database;
    await db.update(table, map,
        where: '${params.keys.first} = ?', whereArgs: [params.values.first]);
  }

  @override
  Future<void> deleteNote(String table, Map<String, Object> params) async {
    final db = await database;
    await db.delete(table,
        where: '${params.keys.first} = ?', whereArgs: [params.values.first]);
  }

  @override
  Future<void> deleteNotes(String table) async {
    final db = await database;
    await db.delete(table);
  }
}
