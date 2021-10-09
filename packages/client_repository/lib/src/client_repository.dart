import 'models/client.dart';

abstract class ClientRepository {
  Future<void> initTable();

  Future<void> dropTable();

  Stream<List<Client>> clients();

  Future<Client> getClient(int id);

  Future<void> addClient(Client client);

  Future<void> addClients(List<Client> clients);

  Future<void> updateClient(Client client);

  Future<void> deleteClient(Client client);

  Future<void> deleteClients();
}
