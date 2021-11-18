import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
    this.id,
    required this.client,
    this.price,
    this.fabrics,
    this.expenses,
    required this.date,
    required this.done,
    this.comment,
  });

  final int? id;
  final int client;
  final int? price;
  final String? fabrics;
  final int? expenses;
  final String date;
  final bool done;
  final String? comment;

  @override
  List<Object?> get props => [
        id,
        client,
        price,
        fabrics,
        expenses,
        date,
        done,
        comment,
      ];

  OrderEntity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        client = map['client'] as int,
        price = map['price'] as int?,
        fabrics = map['fabrics'] as String?,
        expenses = map['expenses'] as int?,
        date = map['date'] as String,
        done = (map['done'] as int) == 1 ? true : false,
        comment = map['comment'] as String?;

  @override
  String toString() {
    return 'OrderEntity {'
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

  Map<String, Object?> toMap() {
    return {
      // TODO: add id for client, fabric, order here. And add new table in db for client_mx_id, fabric_mx_id, order_mx_id
      // don't need id
      'client': client,
      'price': price,
      'fabrics': fabrics,
      'expenses': expenses,
      'date': date,
      'done': done,
      'comment': comment,
    };
  }
}
