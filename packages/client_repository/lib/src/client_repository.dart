import 'models/client.dart';

abstract class ClientRepository {
  Future<void> initDatabase();

  Stream<List<Client>> clients();

  Future<void> addClient(Client client);

  Future<void> updateClient(Client client);

  Future<void> deleteClient(Client client);
}
