import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../widgets/widgets.dart';
import '../blocs/blocs.dart';
import '../constants/routes.dart' as constant_routes;
import '../constants/tooltips.dart' as constant_tooltips;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderBloc = context.read<OrderBloc>();
    orderBloc.add(OrderLoadEvent());
    return Scaffold(
      appBar: const DrawerAppBar(title: 'Заказы'),
      drawer: const AppDrawer(),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (BuildContext context, OrderState state) {
          if (state is OrderLoadingState) {
            return const LoadingCircle();
          } else if (state is OrderDataState) {
            return _OrderList(
              items: state.map,
            );
          } else if (state is OrderErrorState) {
            return ErrorCard(
              error: state.error,
              onRefresh: () {
                orderBloc.add(OrderLoadEvent());
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: BlocBuilder<OrderBloc, OrderState>(
        builder: (BuildContext context, OrderState state) {
          if (state is OrderDataState) {
            return FloatingActionButton(
              tooltip: constant_tooltips.add,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  constant_routes.orderEdit,
                  arguments: {
                    'order': Order(),
                  },
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _OrderList extends StatefulWidget {
  const _OrderList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final Map<int, List<Order>> items;

  @override
  __OrderListState createState() => __OrderListState();
}

class __OrderListState extends State<_OrderList> {
  late final SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clients = widget.items.keys.toList();
    if (widget.items.isEmpty) {
      return Center(
        child: Text(
          'Пусто',
          style: theme.textTheme.bodyText1,
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: clients.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.disabledColor,
          thickness: 1,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        final client = clients[index];
        final orders = widget.items[client]!;
        return OrderCard(
          orders: orders,
        );
      },
    );
  }
}
