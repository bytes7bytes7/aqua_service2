import 'package:database_helper/database_helper.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'client_repository.dart';
import 'constants.dart' as constants;

class SQLiteClientRepository implements ClientRepository {
  const SQLiteClientRepository();

  @override
  Future<void> initTable() async {
    await SQLiteDatabase.instance.init(constants.table, constants.fields);
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
    Map map = await SQLiteDatabase.instance.addNote(
      constants.table,
      client.toEntity().toMap(),
    );
    client.id = map[constants.id];
  }

  @override
  Future<void> addClients(List<Client> clients) {
    List<Map<String, Object?>> lst = [];
    for (Client c in clients) {
      lst.add(c.toEntity().toMap());
    }
    return SQLiteDatabase.instance.addNotes(constants.table, lst);
  }

  @override
  Future<void> updateClient(Client client) async {
    return SQLiteDatabase.instance.updateNote(
      constants.table,
      client.toEntity().toMap(),
      {constants.id: client.id!},
    );
  }

  @override
  Future<void> deleteClient(Client client) async {
    return SQLiteDatabase.instance.deleteNote(
      constants.table,
      {constants.id: client.id!},
    );
  }

  @override
  Future<void> deleteClients() async {
    return SQLiteDatabase.instance.deleteNotes(constants.table);
  }
}
