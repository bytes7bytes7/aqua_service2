import 'package:flutter/material.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../services/number_format_service.dart' as number_format_service;
import '../constants/routes.dart' as constant_routes;

class FabricCard extends StatelessWidget {
  const FabricCard({
    Key? key,
    required this.fabric,
  }) : super(key: key);

  final Fabric fabric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        fabric.title,
        style: theme.textTheme.headline2,
      ),
      subtitle: Text(
        number_format_service.getRidOfZero(fabric.retailPrice.toString()) +
            ' · ' +
            number_format_service.getRidOfZero(fabric.purchasePrice.toString()),
        style: theme.textTheme.subtitle1,
      ),
      trailing: Text(
        number_format_service.getRidOfZero((fabric.retailPrice - fabric.purchasePrice).toString()),
        style: theme.textTheme.headline2!.copyWith(
          color: theme.primaryColor,
        ),
      ),
      hoverColor: theme.disabledColor,
      onTap: () {
        Navigator.of(context).pushNamed(
          constant_routes.fabricEdit,
          arguments: {
            'fabric': fabric,
          },
        );
      },
    );
  }
}
