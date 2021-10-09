import 'package:client_repository/src/constants.dart';
import 'package:client_repository/src/entities/client_entity.dart';
import 'package:database_helper/database_helper.dart';

import 'models/client.dart';
import 'client_repository.dart';

class SQLiteClientRepository implements ClientRepository {
  const SQLiteClientRepository();

  @override
  Future<void> initDatabase() async {
    await SQLiteDatabase.instance.initDatabase(Constants.initDatabase);
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
  Future<void> addClient(Client client) async {
    return SQLiteDatabase.instance.addNote(
      Constants.table,
      client.toEntity().toMap(),
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
  Future<void> updateClient(Client client) async {
    return SQLiteDatabase.instance.updateNote(
      Constants.table,
      client.toEntity().toMap(),
      {Constants.id: client.id!},
    );
  }
}
