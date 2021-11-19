import 'package:collection/collection.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';
import 'package:order_repository/src/entities/entities.dart';

import '../utils/utils.dart';

class Order {
  Order({
    this.id,
    Client? client,
    int? price,
    List<Fabric>? fabrics,
    int? expenses,
    DateTime? date,
    bool? done,
    String? comment,
  })  : client = client ?? Client(),
        price = price ?? 0,
        fabrics = fabrics ?? const <Fabric>[],
        expenses = expenses ?? 0,
        date = date ?? DateTime.now(),
        done = done ?? false,
        comment = comment ?? '';

  int? id;
  Client client;
  int price;
  List<Fabric> fabrics;
  int expenses;
  DateTime date;
  bool done;
  String comment;

  Order.from(Order other)
      : id = other.id,
        client = Client.from(other.client),
        price = other.price,
        fabrics = List.from(other.fabrics),
        expenses = other.expenses,
        date = DateTimeM.from(other.date),
        done = other.done,
        comment = other.comment;

  @override
  int get hashCode =>
      id.hashCode ^
      client.hashCode ^
      price.hashCode ^
      fabrics.hashCode ^
      expenses.hashCode ^
      date.hashCode ^
      done.hashCode ^
      comment.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Order &&
            id == other.id &&
            client == other.client &&
            price == other.price &&
            const ListEquality().equals(fabrics, other.fabrics) &&
            expenses == other.expenses &&
            date == other.date &&
            done == other.done &&
            comment == other.comment;
  }

  @override
  String toString() {
    return 'Order {'
        'id: $id, '
        'client: $client, '
        'price: $price, '
        'fabrics: $fabrics, '
        'expenses: $expenses, '
        'date: $date, '
        'done: $done, '
        'comment: $comment'
        '}';
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      client: client.id!,
      price: price,
      fabrics: fabrics.map((e) => e.id).join(','),
      expenses: expenses,
      date: date.toString(),
      done: done ? 1 : 0,
      comment: comment,
    );
  }

  static Order fromEntity(OrderEntity entity) {
    return Order(
      id: entity.id,
      client: Client(id: entity.client),
      price: entity.price,
      fabrics: entity.fabrics
          ?.split(',')
          .map<Fabric>((e) => Fabric(id: int.parse(e)))
          .toList(),
      expenses: entity.expenses,
      date: DateTime.parse(entity.date),
      done: entity.done == 1 ? true : false,
      comment: entity.comment,
    );
  }
}
