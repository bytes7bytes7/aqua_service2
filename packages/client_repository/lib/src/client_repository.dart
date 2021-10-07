import 'models/client.dart';

abstract class ClientRepository {
  Stream<List<Client>> clients();

  Future<void> addClient(Client client);

  Future<void> updateClient(Client client);

  Future<void> deleteClient(Client client);
}
