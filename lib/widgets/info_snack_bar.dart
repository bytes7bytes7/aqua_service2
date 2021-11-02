import 'package:flutter/material.dart';

SnackBar showInfoSnackBar({
  required BuildContext context,
  required String info,
}) {
  final theme = Theme.of(context);
  return SnackBar(
    content: Text(
      info,
      style: theme.textTheme.bodyText1!
          .copyWith(color: theme.scaffoldBackgroundColor),
    ),
    backgroundColor: theme.primaryColor.withOpacity(0.8),
  );
}
