import 'package:flutter/material.dart';

import '../constants/tooltips.dart' as constant_tooltips;
import '../constants/sizes.dart' as constant_sizes;

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    required this.title,
    this.onExit,
    this.onSave,
    this.snackBarMsg = 'Готово',
    this.hasSearch = false,
  })  : assert(!(hasSearch == true && onSave != null),
            'Impossible configuration: hasSearch = true and onSave != null'),
        super(key: key);

  final String title;
  final String snackBarMsg;
  final VoidCallback? onExit;
  final VoidCallback? onSave;
  final bool hasSearch;

  @override
  Size get preferredSize =>
      const Size.fromHeight(constant_sizes.preferredSizeHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.primaryColor,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: theme.scaffoldBackgroundColor,
        tooltip: constant_tooltips.back,
        splashRadius: constant_sizes.splashRadius,
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if (onExit != null) {
            onExit!();
          } else {
            Navigator.of(context).pop();
          }
        },
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
        if (onSave != null)
          IconButton(
            icon: const Icon(Icons.done),
            color: theme.scaffoldBackgroundColor,
            tooltip: constant_tooltips.save,
            splashRadius: constant_sizes.splashRadius,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              onSave!();
            },
          ),
      ],
    );
  }
}
