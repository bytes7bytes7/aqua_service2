import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fabric_repository/fabric_repository.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../blocs/blocs.dart';
import 'ask_bottom_sheet.dart';
import 'fabrics_inherited.dart';
import '../constants/routes.dart' as constant_routes;
import '../constants/sizes.dart' as constant_sizes;

class FabricCard extends StatelessWidget {
  const FabricCard({
    Key? key,
    required this.fabric,
    required this.controller,
    this.fabricsInherited,
  }) : super(key: key);

  final Fabric fabric;
  final SlidableController controller;
  final FabricsInherited? fabricsInherited;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabricBloc = context.read<FabricBloc>();

    ValueNotifier<int> amount = ValueNotifier(0);
    final ValueNotifier<bool> isSelected = ValueNotifier(false);

    if (fabricsInherited != null) {
      amount.value =
          fabricsInherited!.selected.where((e) => e.id == fabric.id).length;
      isSelected.value = fabricsInherited!.selected.contains(fabric);
    }

    return Slidable(
      key: Key('${fabric.hashCode}'),
      controller: controller,
      direction: Axis.horizontal,
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        hoverColor: theme.disabledColor,
        leading: fabricsInherited != null
            ? ValueListenableBuilder(
                valueListenable: isSelected,
                builder: (context, bool value, child) {
                  return Checkbox(
                    value: value,
                    checkColor: theme.scaffoldBackgroundColor,
                    fillColor: MaterialStateProperty.resolveWith(
                        (states) => theme.primaryColor),
                    onChanged: (bool? _) {
                      if (value) {
                        fabricsInherited!.removeAllItems(fabric);
                        isSelected.value = false;
                      } else {
                        fabricsInherited!.addItem(fabric);
                        isSelected.value = true;
                      }
                    },
                  );
                },
              )
            : null,
        title: Text(
          fabric.title,
          style: theme.textTheme.headline2,
        ),
        subtitle: ValueListenableBuilder(
          valueListenable: amount,
          builder: (context, int value, child) {
            final amountTimesPrice =
                amount.value * (fabric.retailPrice - fabric.purchasePrice);
            return Text(
              (value > 0)
                  ? '${fabric.retailPrice - fabric.purchasePrice} × $value = $amountTimesPrice'
                  : '${fabric.retailPrice - fabric.purchasePrice}',
              style: theme.textTheme.subtitle1,
            );
          },
        ),
        trailing: (fabricsInherited != null)
            ? FittedBox(
                child: ValueListenableBuilder(
                  valueListenable: amount,
                  builder: (context, int value, child) {
                    return Row(
                      children: [
                        if (fabric.actualTime == null)
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_left),
                            color: theme.primaryColor,
                            splashRadius: constant_sizes.splashRadius,
                            onPressed: () {
                              if (amount.value > 0) {
                                amount.value--;
                              }
                              fabricsInherited!.removeOneItem(fabric);
                            },
                          ),
                        Text(
                          '$value',
                          style: theme.textTheme.headline2!.copyWith(),
                        ),
                        if (fabric.actualTime == null)
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right),
                            color: theme.primaryColor,
                            splashRadius: constant_sizes.splashRadius,
                            onPressed: () {
                              amount.value++;
                              fabricsInherited!.addItem(fabric);
                            },
                          ),
                      ],
                    );
                  },
                ),
              )
            : null,
        onTap: () {
          Navigator.of(context).pushNamed(
            constant_routes.fabricEdit,
            arguments: {
              'fabric': fabric,
            },
          );
        },
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
