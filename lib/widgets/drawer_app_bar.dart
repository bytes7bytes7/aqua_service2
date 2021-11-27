import 'package:flutter/material.dart';

import '../constants/tooltips.dart' as constant_tooltips;
import '../constants/sizes.dart' as constant_sizes;

class DrawerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawerAppBar({
    Key? key,
    required this.title,
    this.hasSearch = false,
  }) : super(key: key);

  final String title;
  final bool hasSearch;

  @override
  Size get preferredSize => const Size.fromHeight(constant_sizes.preferredSizeHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.primaryColor,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: theme.scaffoldBackgroundColor,
        tooltip: constant_tooltips.drawer,
        splashRadius: constant_sizes.splashRadius,
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        if (hasSearch)
          IconButton(
            icon: const Icon(Icons.search),
            color: theme.scaffoldBackgroundColor,
            tooltip: constant_tooltips.search,
            splashRadius: constant_sizes.splashRadius,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              // TODO: add search
            },
          ),
      ],
    );
  }
}
