import 'package:flutter/material.dart';

Future<void> showNoYesAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String lBtnText,
  required String rBtnText,
  required VoidCallback rBtnPressed,
  required VoidCallback lBtnPressed,
}) async {
  final theme = Theme.of(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: theme.textTheme.headline1,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                description,
                style: theme.textTheme.bodyText1,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              lBtnText,
              style: theme.textTheme.subtitle2!
                  .copyWith(color: theme.primaryColor),
            ),
            onPressed: lBtnPressed,
          ),
          TextButton(
            child: Text(
              rBtnText,
              style: theme.textTheme.subtitle2!
                  .copyWith(color: theme.errorColor),
            ),
            onPressed: rBtnPressed,
          ),
        ],
      );
    },
  );
}
