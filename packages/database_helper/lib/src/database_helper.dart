import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelper {
  Future<Database> get database;

  Future<void> init(String table, Map<String, Map<Type, bool>> fields);

  Future<void> dropTable(String table, Map<String, Map<Type, bool>> fields);

  Future<Map<String, dynamic>> getNote(
      String table, Map<String, Object> params);

  Future<List<Map<String, dynamic>>> getNotes(String table);

  Future<Map<String, Object?>> addNote(String table, Map<String, Object?> map);

  Future<void> addNotes(String table, List<Map<String, Object?>> lst);

  Future<void> updateNote(
      String table, Map<String, Object?> map, Map<String, Object> params);

  Future<void> deleteNote(String table, Map<String, Object> params);

  Future<void> deleteNotes(String table);
}
