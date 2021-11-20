import 'package:database_helper/database_helper.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'fabric_repository.dart';
import 'constants.dart' as constants;

class SQLiteFabricRepository implements FabricRepository {
  SQLiteFabricRepository();

  static late int _maxID;

  @override
  int get maxID => _maxID;

  Future<void> _setMaxID() async {
    _maxID = await SQLiteDatabase.instance.getMaxID(constants.table);
  }

  @override
  Future<void> initTable() async {
    await SQLiteDatabase.instance.init(constants.table, constants.fields);
    await SQLiteDatabase.instance.init(constants.archiveTable,
        constants.fields..addAll(constants.timeField), false);
    await _setMaxID();
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
  Future<List<Fabric>> getFabrics(List<int> id) async {
    var data = await SQLiteDatabase.instance
        .getNotes(constants.table, {constants.id: id});
    List<Fabric> fabrics = [];
    for (Map<String, Object?> m in data) {
      fabrics.add(Fabric.fromEntity(FabricEntity.fromMap(m)));
    }
    return fabrics;
  }

  @override
  Future<void> addFabric(Fabric fabric) async {
    fabric.id = maxID;
    await SQLiteDatabase.instance.addNote(
      constants.table,
      fabric.toEntity().toMap(),
    );
    _maxID++;
    SQLiteDatabase.instance.updateMaxID(constants.table, maxID);
  }

  @override
  Future<void> addFabrics(List<Fabric> fabrics) async {
    List<Map<String, Object?>> lst = [];
    int mx = maxID;
    for (Fabric f in fabrics) {
      f.id = mx;
      lst.add(f.toEntity().toMap());
      mx++;
    }
    _maxID = mx;
    SQLiteDatabase.instance.addNotes(constants.table, lst);
    SQLiteDatabase.instance.updateMaxID(constants.table, maxID);
  }

  @override
  Future<void> updateFabric(Fabric fabric) async {
    SQLiteDatabase.instance.updateNote(
      constants.table,
      fabric.toEntity().toMap(),
      {constants.id: fabric.id!},
    );
  }

  @override
  Future<void> deleteFabric(Fabric fabric) async {
    SQLiteDatabase.instance.deleteNote(
      constants.table,
      {constants.id: fabric.id!},
    );
  }

  @override
  Future<void> deleteFabrics() async {
    SQLiteDatabase.instance.deleteNotes(constants.table);
  }

  @override
  Future<void> archiveFabric(Fabric fabric) async {
    fabric.actualTime = DateTime.now();
    await SQLiteDatabase.instance.addNote(
      constants.archiveTable,
      fabric.toEntity().toMap(archived: true),
    );
  }

  @override
  Future<void> archiveFabrics(List<Fabric> fabrics) async {
    List<Map<String, Object?>> lst = [];
    for (Fabric f in fabrics) {
      f.actualTime = DateTime.now();
      lst.add(f.toEntity().toMap(archived: true));
    }
    SQLiteDatabase.instance.addNotes(constants.archiveTable, lst);
  }
}
