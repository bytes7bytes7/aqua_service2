import 'client.dart';
import 'fabric.dart';

class Order {
  Order({
    this.id,
    this.client,
    this.price = 0.0,
    this.fabrics,
    this.expenses = 0.0,
    this.date = '',
    this.done = false,
    this.comment = '',
  });

  int? id;
  Client? client;
  double price;
  List<Fabric>? fabrics;
  double expenses;
  String date;
  bool done;
  String comment;
}