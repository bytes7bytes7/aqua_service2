import 'models/models.dart';

abstract class OrderRepository{
  int get maxID;

  Future<void> initTable();

  Future<void> dropTable();

  // int -> client id
  Stream<Map<int, List<Order>>> orders();

  Future<Order> getOrder(int id);

  Future<void> addOrder(Order order);

  Future<void> addOrders(List<Order> orders);

  Future<void> updateOrder(Order order);

  Future<void> deleteOrder(Order order);

  Future<void> deleteOrders();

  Future<void> archiveOrder(Order order);

  Future<void> archiveOrders(List<Order> orders);
}