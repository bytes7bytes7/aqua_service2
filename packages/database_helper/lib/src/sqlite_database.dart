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
  Future<void> init(String sql) async {
    final db = await database;
    await db.execute(sql);
  }

  @override
  Future<void> dropTable(String table, String sql) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $table;');
    await init(sql);
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
  Future<void> addNote(String table, Map<String, Object?> map) async{
    final db = await database;
    await db.insert(table, map);
  }

  @override
  Future<void> addNotes(String table, List<Map<String, Object?>> lst) async {
    final db = await database;
    await db.transaction((txn) async {
      for(Map<String, Object?> map in lst){
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
