import 'models/client.dart';
import 'client_repository.dart';

class SQLiteClientRepository extends ClientRepository {
  @override
  Future<void> addClient(Client client) async {
    print('SQLiteClientRepository: addClient no implemented');
  }

  @override
  Stream<List<Client>> clients() {
    return Stream.fromFuture(
      Future.delayed(
        const Duration(seconds: 3),
        () {
          return List.generate(
            3,
            (index) => Client(
              id: index,
              name: 'Name $index',
              city: 'City $index',
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> deleteClient(Client client) async {
    print('SQLiteClientRepository: deleteClient no implemented');
  }

  @override
  Future<void> updateClient(Client client) async {
    print('SQLiteClientRepository: updateClient no implemented');
  }
}
