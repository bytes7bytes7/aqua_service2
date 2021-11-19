import 'package:database_helper/database_helper.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'order_repository.dart';
import 'constants.dart' as constants;

class SQLiteOrderRepository implements OrderRepository {
  SQLiteOrderRepository();

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
  Stream<Map<int, List<Order>>> orders() {
    return Stream.fromFuture(
      SQLiteDatabase.instance.getNotes(constants.table).then(
        (lst) async {
          Map<int, List<Order>> map = {};
          for (Map<String, Object?> m in lst) {
            Order o = Order.fromEntity(OrderEntity.fromMap(m));
            o.client = await SQLiteClientRepository().getClient(o.client.id!);
            if (map.containsKey(o.client.id)) {
              (map[o.client.id] as List).add(o);
            } else {
              map[o.client.id!] = [o];
            }
          }
          return map;
        },
      ),
    );
  }

  @override
  Future<Order> getOrder(int id) async {
    var map = await SQLiteDatabase.instance
        .getNote(constants.table, {constants.id: id});
    return Order.fromEntity(OrderEntity.fromMap(map));
  }

  @override
  Future<void> addOrder(Order order) async {
    final map = order.toEntity().toMap();
    map[constants.id] = maxID;
    await SQLiteDatabase.instance.addNote(
      constants.table,
      order.toEntity().toMap(),
    );
    _maxID++;
    SQLiteDatabase.instance.updateMaxID(constants.table, maxID);
  }

  @override
  Future<void> addOrders(List<Order> orders) async {
    List<Map<String, Object?>> lst = [];
    int mx = maxID;
    for (Order o in orders) {
      final map = o.toEntity().toMap();
      map[constants.id] = mx;
      lst.add(map);
      mx++;
    }
    _maxID = mx;
    SQLiteDatabase.instance.addNotes(constants.table, lst);
    SQLiteDatabase.instance.updateMaxID(constants.table, maxID);
  }

  @override
  Future<void> updateOrder(Order order) async {
    SQLiteDatabase.instance.updateNote(
      constants.table,
      order.toEntity().toMap(),
      {constants.id: order.id!},
    );
  }

  @override
  Future<void> deleteOrder(Order order) async {
    SQLiteDatabase.instance.deleteNote(
      constants.table,
      {constants.id: order.id!},
    );
  }

  @override
  Future<void> deleteOrders() async {
    SQLiteDatabase.instance.deleteNotes(constants.table);
  }

  @override
  Future<void> archiveOrder(Order order) async {
    order.done = true;
    await updateOrder(order);

    final clientRepo = SQLiteClientRepository();
    final fabricRepo = SQLiteFabricRepository();

    await clientRepo.archiveClient(order.client);
    await fabricRepo.archiveFabrics(order.fabrics);
  }

  @override
  Future<void> archiveOrders(List<Order> orders) async {
    final clientRepo = SQLiteClientRepository();
    final fabricRepo = SQLiteFabricRepository();

    List<Client> clients = [];
    List<Fabric> fabrics = [];

    for (Order order in orders) {
      order.done = true;
      await updateOrder(order);
      clients.add(order.client);
      fabrics.addAll(order.fabrics);
    }

    await clientRepo.archiveClients(clients);
    await fabricRepo.archiveFabrics(fabrics);
  }
}
