import 'models/client.dart';

abstract class ClientRepository {
  int get maxID;

  Future<void> initTable();

  Future<void> dropTable();

  Stream<List<Client>> clients();

  Future<Client> getClient(int id);

  Future<void> addClient(Client client);

  Future<void> addClients(List<Client> clients);

  Future<void> updateClient(Client client);

  Future<void> archiveClient(
    Client client, {
    bool delete = false,
    DateTime? dateTime,
  });

  Future<void> archiveClients(
    List<Client> client, {
    bool delete = false,
    DateTime? dateTime,
  });
}
