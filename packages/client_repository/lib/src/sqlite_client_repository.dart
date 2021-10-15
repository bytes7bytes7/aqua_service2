import 'package:database_helper/database_helper.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'client_repository.dart';
import 'constants.dart';

class SQLiteClientRepository implements ClientRepository {
  const SQLiteClientRepository();

  @override
  Future<void> initTable() async {
    await SQLiteDatabase.instance.init(Constants.table, Constants.fields);
  }

  @override
  Future<void> dropTable() async {
    await SQLiteDatabase.instance.dropTable(Constants.table, Constants.fields);
  }

  @override
  Stream<List<Client>> clients() {
    return Stream.fromFuture(
      SQLiteDatabase.instance.getNotes(Constants.table).then(
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
        .getNote(Constants.table, {Constants.id: id});
    return Client.fromEntity(ClientEntity.fromMap(map));
  }

  @override
  Future<void> addClient(Client client) async {
    Map map = await SQLiteDatabase.instance.addNote(
      Constants.table,
      client.toEntity().toMap(),
    );
    client.id = map[Constants.id];
  }

  @override
  Future<void> addClients(List<Client> clients) {
    List<Map<String, Object?>> lst = [];
    for (Client c in clients) {
      lst.add(c.toEntity().toMap());
    }
    return SQLiteDatabase.instance.addNotes(Constants.table, lst);
  }

  @override
  Future<void> updateClient(Client client) async {
    return SQLiteDatabase.instance.updateNote(
      Constants.table,
      client.toEntity().toMap(),
      {Constants.id: client.id!},
    );
  }

  @override
  Future<void> deleteClient(Client client) async {
    return SQLiteDatabase.instance.deleteNote(
      Constants.table,
      {Constants.id: client.id!},
    );
  }

  @override
  Future<void> deleteClients() async {
    return SQLiteDatabase.instance.deleteNotes(Constants.table);
  }
}
