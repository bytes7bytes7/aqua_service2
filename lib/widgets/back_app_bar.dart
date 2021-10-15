import 'package:flutter/material.dart';

import '../constants.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback? onPressed;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.primaryColor,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: theme.scaffoldBackgroundColor,
        tooltip: ConstantTooltips.back,
        splashRadius: ConstantSizes.splashRadius,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        if (onPressed != null)
          IconButton(
            icon: const Icon(Icons.done),
            color: theme.scaffoldBackgroundColor,
            tooltip: ConstantTooltips.save,
            splashRadius: ConstantSizes.splashRadius,
            onPressed: onPressed,
          ),
      ],
    );
  }
}
