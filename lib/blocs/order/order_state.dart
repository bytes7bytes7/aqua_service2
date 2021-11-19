part of 'order_bloc.dart';

class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderLoadingState extends OrderState {}

class OrderDataState extends OrderState {
  const OrderDataState(this.map);

  // int -> client id
  final Map<int, List<Order>> map;

  @override
  List<Object?> get props => [map];

  @override
  String toString() => 'OrderDataState {orders: $map}';
}

class OrderErrorState extends OrderState {
  const OrderErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'OrderErrorState {error: $error}';
}
