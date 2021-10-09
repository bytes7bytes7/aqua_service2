import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelper {
  Future<Database> get database;

  Future<void> initDatabase(String sql);

  Future<void> dropTable(String table, String sql);

  Future<Map<String, dynamic>> getNote(String table, Map<String, Object> params);

  Future<List<Map<String, dynamic>>> getNotes(String table);

  Future<void> addNote(String table, Map<String, Object?> map);

  Future<void> addNotes(String table, List<Map<String, Object?>> map);

  Future<void> updateNote(String table, Map<String, Object?> map, Map<String, Object> params);

  Future<void> deleteNote(String table, Map<String, Object> params);

  Future<void> deleteNotes(String table);
}
