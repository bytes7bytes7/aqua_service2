import 'package:flutter/material.dart';
import 'package:fabric_repository/fabric_repository.dart';

import 'fabrics_inherited.dart';
import '../constants/routes.dart' as constant_routes;

class FabricCard extends StatefulWidget {
  const FabricCard({
    Key? key,
    required this.fabric,
  }) : super(key: key);

  final Fabric fabric;

  @override
  State<FabricCard> createState() => _FabricCardState();
}

class _FabricCardState extends State<FabricCard> {
  late final ValueNotifier<bool> isSelected;
  late final FabricsInherited fabricsInherited;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    fabricsInherited = FabricsInherited.of(context);
    isSelected =
        ValueNotifier(fabricsInherited.selected.contains(widget.fabric));
    return ListTile(
      hoverColor: theme.disabledColor,
      leading: fabricsInherited.isChoice
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
                      fabricsInherited.removeItem(widget.fabric);
                      isSelected.value = false;
                    } else {
                      fabricsInherited.addItem(widget.fabric);
                      isSelected.value = true;
                    }
                  },
                );
              },
            )
          : null,
      title: Text(
        widget.fabric.title,
        style: theme.textTheme.headline2,
      ),
      subtitle: Text(
        '${widget.fabric.retailPrice} · ${widget.fabric.purchasePrice}',
        style: theme.textTheme.subtitle1,
      ),
      trailing: Text(
        '${widget.fabric.retailPrice - widget.fabric.purchasePrice}',
        style: theme.textTheme.headline2!.copyWith(
          color: theme.primaryColor,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          constant_routes.fabricEdit,
          arguments: {
            'fabric': widget.fabric,
          },
        );
      },
    );
  }
}
