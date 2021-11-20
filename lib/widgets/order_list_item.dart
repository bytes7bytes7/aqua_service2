import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../constants/sizes.dart' as constant_sizes;
import '../constants/routes.dart' as constant_routes;

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String day = order.date.day.toString();
    String month = order.date.month.toString();
    String year = order.date.year.toString();
    if (day.length < 2) {
      day = '0' + day;
    }
    if (month.length < 2) {
      month = '0' + month;
    }
    if (year.length == 4) {
      year = year.substring(2);
    }
    final date = '$day.$month.$year';
    int profit = order.price;
    for (Fabric f in order.fabrics) {
      final retailPrice = f.retailPrice;
      final purchasePrice = f.purchasePrice;
      profit += retailPrice - purchasePrice;
    }
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: InkWell(
        highlightColor: theme.disabledColor.withOpacity(0.3),
        splashColor: theme.primaryColor.withOpacity(0.3),
        onTap: () {
          Navigator.of(context).pushNamed(
            constant_routes.orderEdit,
            arguments: {
              'order': order,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: constant_sizes.avatarRadius),
          child: Column(
            children: [
              Divider(
                color: theme.disabledColor,
                thickness: 1,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                    0, 15.0, constant_sizes.horizontalPadding, 15.0),
                child: Row(
                  children: [
                    Icon(
                      order.done ? Icons.done_all_outlined : Icons.done,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      date,
                      style: theme.textTheme.bodyText1,
                    ),
                    const Spacer(),
                    Text(
                      '$profit',
                      style: theme.textTheme.headline2!.copyWith(
                          color: profit >= 0 ? theme.primaryColor : theme.errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
