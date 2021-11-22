import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../constants/routes.dart' as constant_routes;
import '../constants/sizes.dart' as constant_sizes;
import '../blocs/blocs.dart';
import 'widgets.dart';

class FabricListItem extends StatelessWidget {
  const FabricListItem({
    Key? key,
    required this.fabric,
    required this.controller,
  }) : super(key: key);

  final Fabric fabric;
  final SlidableController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabricBloc = context.read<FabricBloc>();
    return Slidable(
      key: Key('${fabric.hashCode}'),
      controller: controller,
      direction: Axis.horizontal,
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: InkWell(
          splashColor: theme.disabledColor,
          onTap: () {
            Navigator.of(context).pushNamed(
              constant_routes.fabricEdit,
              arguments: {
                'fabric': fabric,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: constant_sizes.textFieldVerPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fabric.title,
                      style: theme.textTheme.headline2,
                    ),
                    Text(
                      '${fabric.retailPrice} · ${fabric.purchasePrice}',
                      style: theme.textTheme.subtitle1,
                    ),
                  ],
                ),
                Text(
                  '${fabric.retailPrice - fabric.purchasePrice}',
                  style: theme.textTheme.headline2!
                      .copyWith(color: theme.primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Удалить',
          color: theme.errorColor,
          icon: Icons.delete,
          onTap: () {
            showAskBottomSheet(
              context: context,
              title: 'Вы действительно хотите удалить материал?',
              text1: 'Отмена',
              text2: 'Удалить',
              onPressed2: () {
                fabricBloc.add(FabricDeleteEvent(fabric));
              },
            );
          },
        ),
      ],
    );
  }
}
