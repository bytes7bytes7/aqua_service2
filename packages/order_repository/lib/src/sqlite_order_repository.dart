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
          Map<int, List<Order>> data = {};
          for (Map<String, Object?> m in lst) {
            Order o = Order.fromEntity(OrderEntity.fromMap(m));
            o.client = await SQLiteClientRepository().getClient(o.client.id!);
            List<int> fabrics = o.fabrics.map((e) => e.id!).toList();
            o.fabrics = await SQLiteFabricRepository().getFabrics(fabrics);
            if (data.containsKey(o.client.id)) {
              (data[o.client.id] as List).add(o);
            } else {
              data[o.client.id!] = [o];
            }
          }
          // TODO: add sorting by client's name
          return data;
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
  Future<void> archiveOrder(Order order) async {
    order.done = true;
    await updateOrder(order);

    final clientRepo = SQLiteClientRepository();
    final fabricRepo = SQLiteFabricRepository();

    DateTime now = DateTime.now();

    await clientRepo.archiveClient(order.client, dateTime: now);
    await fabricRepo.archiveFabrics(order.fabrics, dateTime: now);
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

    DateTime now = DateTime.now();

    await clientRepo.archiveClients(clients, dateTime: now);
    await fabricRepo.archiveFabrics(fabrics, dateTime: now);
  }

  @override
  Future<void> deleteOrder(Order order) async {
    SQLiteDatabase.instance.deleteNote(
      constants.table,
      {constants.id: order.id!},
    );
  }

  @override
  Future<void> deleteOrders(List<Order> orders) async {
    SQLiteDatabase.instance.deleteNotes(
      constants.table,
      {constants.id: orders.map<int>((e) => e.id!).toList()},
    );
  }
}
