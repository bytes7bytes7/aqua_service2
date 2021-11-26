import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fabric_repository/fabric_repository.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../blocs/blocs.dart';
import 'ask_bottom_sheet.dart';
import '../constants/routes.dart' as constant_routes;
import '../constants/sizes.dart' as constant_sizes;

class FabricCard extends StatelessWidget {
  const FabricCard({
    Key? key,
    required this.fabric,
    required this.controller,
    this.fabricsNotifier,
  }) : super(key: key);

  final Fabric fabric;
  final SlidableController controller;
  final ValueNotifier<List<Fabric>>? fabricsNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabricBloc = context.read<FabricBloc>();

    ValueNotifier<int> amount = ValueNotifier(0);

    if (fabricsNotifier != null) {
      amount.value =
          fabricsNotifier!.value.where((e) => e.id == fabric.id).length;
    }

    return Slidable(
      key: Key('${fabric.hashCode}'),
      controller: controller,
      direction: Axis.horizontal,
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        hoverColor: theme.disabledColor,
        leading: fabricsNotifier != null
            ? ValueListenableBuilder(
                valueListenable: amount,
                builder: (context, int value, child) {
                  return Checkbox(
                    value: value > 0,
                    checkColor: theme.scaffoldBackgroundColor,
                    fillColor: MaterialStateProperty.resolveWith(
                        (states) => theme.primaryColor),
                    onChanged: (bool? _) {
                      if (value > 0) {
                        if (fabricsNotifier!.value.contains(fabric)) {
                          fabricsNotifier!.value = List.from(
                              fabricsNotifier!.value
                                ..removeWhere((e) => e.id == fabric.id));
                        }
                        amount.value = 0;
                      } else {
                        fabricsNotifier!.value =
                            List.from(fabricsNotifier!.value..add(fabric));
                        amount.value = 1;
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
        trailing: (fabricsNotifier != null)
            ? ValueListenableBuilder(
                valueListenable: amount,
                builder: (context, int value, child) {
                  if (amount.value <= 0) {
                    return const SizedBox.shrink();
                  }
                  return FittedBox(
                    child: Row(
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
                              fabricsNotifier!.value = List.from(
                                  fabricsNotifier!.value..remove(fabric));
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
                              fabricsNotifier!.value = List.from(
                                  fabricsNotifier!.value..add(fabric));
                            },
                          ),
                      ],
                    ),
                  );
                },
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
                if(fabricsNotifier != null) {
                  fabricsNotifier!.value = List.from(fabricsNotifier!.value..removeWhere((e) => e.id == fabric.id));
                }
                fabricBloc.add(FabricDeleteEvent(fabric));
              },
            );
          },
        ),
      ],
    );
  }
}
