import 'package:flutter/material.dart';

import '../constants.dart';

class DrawerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawerAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.primaryColor,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: theme.scaffoldBackgroundColor,
        tooltip: ConstantTooltips.drawer,
        splashRadius: ConstantSizes.splashRadius,
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}
