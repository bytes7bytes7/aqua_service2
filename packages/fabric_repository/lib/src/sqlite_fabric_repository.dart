import 'package:database_helper/database_helper.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'fabric_repository.dart';
import 'constants.dart' as constants;

class SQLiteFabricRepository implements FabricRepository {
  const SQLiteFabricRepository();

  @override
  Future<void> initTable() async {
    await SQLiteDatabase.instance.init(constants.table, constants.fields);
  }

  @override
  Future<void> dropTable() async {
    await SQLiteDatabase.instance.dropTable(constants.table, constants.fields);
  }

  @override
  Stream<List<Fabric>> fabrics() {
    return Stream.fromFuture(
      SQLiteDatabase.instance.getNotes(constants.table).then(
        (lst) {
          return lst
              .map<Fabric>((e) => Fabric.fromEntity(FabricEntity.fromMap(e)))
              .toList();
        },
      ),
    );
  }

  @override
  Future<Fabric> getFabric(int id) async {
    var map = await SQLiteDatabase.instance
        .getNote(constants.table, {constants.id: id});
    return Fabric.fromEntity(FabricEntity.fromMap(map));
  }

  @override
  Future<void> addFabric(Fabric fabric) async {
    Map map = await SQLiteDatabase.instance.addNote(
      constants.table,
      fabric.toEntity().toMap(),
    );
    fabric.id = map[constants.id];
  }

  @override
  Future<void> addFabrics(List<Fabric> fabrics) async {
    List<Map<String, Object?>> lst = [];
    for (Fabric f in fabrics) {
      lst.add(f.toEntity().toMap());
    }
    return SQLiteDatabase.instance.addNotes(constants.table, lst);
  }

  @override
  Future<void> updateFabric(Fabric fabric) async {
    return SQLiteDatabase.instance.updateNote(
      constants.table,
      fabric.toEntity().toMap(),
      {constants.id: fabric.id!},
    );
  }

  @override
  Future<void> deleteFabric(Fabric fabric) async {
    return SQLiteDatabase.instance.deleteNote(
      constants.table,
      {constants.id: fabric.id!},
    );
  }

  @override
  Future<void> deleteFabrics() async {
    return SQLiteDatabase.instance.deleteNotes(constants.table);
  }
}
