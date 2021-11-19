part of 'order_bloc.dart';

class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderLoadEvent extends OrderEvent {}

class OrderAddEvent extends OrderEvent {
  const OrderAddEvent(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];

  @override
  String toString() => 'OrderAddEvent {order: $order}';
}

class OrderUpdateEvent extends OrderEvent {
  const OrderUpdateEvent(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];

  @override
  String toString() => 'OrderUpdateEvent {order: $order}';
}

class OrderDeleteEvent extends OrderEvent {
  const OrderDeleteEvent(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];

  @override
  String toString() => 'OrderDeleteEvent {order: $order}';
}
