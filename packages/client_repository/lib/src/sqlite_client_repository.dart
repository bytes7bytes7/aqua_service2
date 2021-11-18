import 'package:database_helper/database_helper.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'client_repository.dart';
import 'constants.dart' as constants;

class SQLiteClientRepository implements ClientRepository {
  SQLiteClientRepository();

  static late int _maxID;

  @override
  int get maxID => _maxID;

  Future<void> _setMaxID() async {
    _maxID = await SQLiteDatabase.instance.getMaxID(constants.table);
  }

  @override
  Future<void> initTable() async {
    await SQLiteDatabase.instance.init(constants.table, constants.fields);
    await _setMaxID();
  }

  @override
  Future<void> dropTable() async {
    await SQLiteDatabase.instance.dropTable(constants.table, constants.fields);
  }

  @override
  Stream<List<Client>> clients() {
    return Stream.fromFuture(
      SQLiteDatabase.instance.getNotes(constants.table).then(
        (lst) {
          return lst
              .map<Client>((e) => Client.fromEntity(ClientEntity.fromMap(e)))
              .toList();
        },
      ),
    );
  }

  @override
  Future<Client> getClient(int id) async {
    var map = await SQLiteDatabase.instance
        .getNote(constants.table, {constants.id: id});
    return Client.fromEntity(ClientEntity.fromMap(map));
  }

  @override
  Future<void> addClient(Client client) async {
    client.id = maxID;
    await SQLiteDatabase.instance.addNote(
      constants.table,
      client.toEntity().toMap(),
    );
    _maxID++;
    SQLiteDatabase.instance.updateMaxID(constants.table, maxID);
  }

  @override
  Future<void> addClients(List<Client> clients) async {
    List<Map<String, Object?>> lst = [];
    int mx = maxID;
    for (Client c in clients) {
      c.id = mx;
      lst.add(c.toEntity().toMap());
      mx++;
    }
    _maxID = mx;
    SQLiteDatabase.instance.addNotes(constants.table, lst);
    SQLiteDatabase.instance.updateMaxID(constants.table, maxID);
  }

  @override
  Future<void> updateClient(Client client) async {
     SQLiteDatabase.instance.updateNote(
      constants.table,
      client.toEntity().toMap(),
      {constants.id: client.id!},
    );
  }

  @override
  Future<void> deleteClient(Client client) async {
     SQLiteDatabase.instance.deleteNote(
      constants.table,
      {constants.id: client.id!},
    );
  }

  @override
  Future<void> deleteClients() async {
     SQLiteDatabase.instance.deleteNotes(constants.table);
  }

  @override
  Future<void> archiveClient(Client client) async {
    await SQLiteDatabase.instance.addNote(
      constants.archiveTable,
      client.toEntity().toMap(),
    );
  }

  @override
  Future<void> archiveClients(List<Client> clients) async {
    List<Map<String, Object?>> lst = [];
    for (Client c in clients) {
      lst.add(c.toEntity().toMap());
    }
    SQLiteDatabase.instance.addNotes(constants.archiveTable, lst);
  }
}
