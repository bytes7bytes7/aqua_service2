import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/order_repository.dart';

part 'order_state.dart';

part 'order_event.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(OrderRepository orderRepository)
      : _orderRepository = orderRepository,
        super(OrderLoadingState()) {
    on<OrderLoadEvent>(_loadOrder);
    on<OrderAddEvent>(_addOrder);
    on<OrderUpdateEvent>(_updateOrder);
    on<OrderDeleteEvent>(_deleteOrder);
    on<OrderArchiveEvent>(_archiveOrder);
  }

  final OrderRepository _orderRepository;

  Future<void> _loadOrder(OrderLoadEvent event, Emitter<OrderState> emit) {
    if (state is! OrderLoadingState) {
      emit(OrderLoadingState());
    }
    return emit.onEach<Map<int, List<Order>>>(
      _orderRepository.orders(),
      onData: (map) => emit(
        OrderDataState(map),
      ),
      onError: (Object error, StackTrace stackTrace) => emit(
        OrderErrorState('$error\n\n$stackTrace'),
      ),
    );
  }

  void _addOrder(OrderAddEvent event, Emitter<OrderState> emit) {
    _orderRepository
        .addOrder(event.order)
        .then((value) => add(OrderLoadEvent()));
  }

  void _updateOrder(OrderUpdateEvent event, Emitter<OrderState> emit) {
    _orderRepository
        .updateOrder(event.order)
        .then((value) => add(OrderLoadEvent()));
  }

  void _deleteOrder(OrderDeleteEvent event, Emitter<OrderState> emit) {
    _orderRepository
        .deleteOrder(event.order)
        .then((value) => add(OrderLoadEvent()));
  }

  void _archiveOrder(OrderArchiveEvent event, Emitter<OrderState> emit) {
    _orderRepository
        .archiveOrder(event.order)
        .then((value) => add(OrderLoadEvent()));
  }
}
