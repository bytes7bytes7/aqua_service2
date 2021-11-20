import 'package:aqua_service2/widgets/order_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_repository/image_repository.dart';
import 'package:order_repository/order_repository.dart';

import '../blocs/blocs.dart';
import '../constants/sizes.dart' as constant_sizes;
import '../constants/routes.dart' as constant_routes;
import 'ask_bottom_sheet.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final List<Order> orders;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final GlobalKey<ExpansionTileCardState> cardKey = GlobalKey();
  late final SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderBloc = context.read<OrderBloc>();
    final client = widget.orders[0].client;
    final orders = widget.orders;
    return ExpansionTileCard(
      key: cardKey,
      elevation: 0,
      borderRadius: BorderRadius.circular(0),
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor,
        radius: constant_sizes.avatarRadius + 1,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: BlocProvider<AvatarBloc>(
            create: (context) {
              return AvatarBloc(const ImageRepository())
                ..add(AvatarLoadEvent(client.avatarPath));
            },
            child: BlocBuilder<AvatarBloc, AvatarState>(
              builder: (BuildContext context, AvatarState state) {
                if (state is AvatarDataState && state.avatar.isNotEmpty) {
                  return CircleAvatar(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    radius: constant_sizes.avatarRadius,
                    foregroundImage: MemoryImage(state.avatar),
                  );
                }
                return CircleAvatar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  radius: constant_sizes.avatarRadius,
                  child: Text(
                    client.name.isNotEmpty ? client.name[0] : '${client.id}',
                    style: theme.textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: theme.primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      title: Text(
        client.name,
        style: theme.textTheme.headline2,
      ),
      subtitle: Text(
        client.city,
        style: theme.textTheme.subtitle1,
      ),
      children: List.generate(
        orders.length,
        (index) {
          return Slidable(
            key: Key('order ${orders[index].id}'),
            controller: slidableController,
            direction: Axis.horizontal,
            actionPane: const SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: OrderListItem(
              order: orders[index],
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Удалить',
                color: theme.errorColor,
                icon: Icons.delete,
                onTap: () {
                  showAskBottomSheet(
                    context: context,
                    title: 'Вы действительно хотите удалить заказ?',
                    text1: 'Отмена',
                    text2: 'Удалить',
                    onPressed2: () {
                      orderBloc.add(OrderDeleteEvent(orders[index]));
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
