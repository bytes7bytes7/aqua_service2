import 'package:flutter/material.dart';

import 'wide_button.dart';

void showAskBottomSheet({
  required BuildContext context,
  required String title,
  required String text1,
  required String text2,
  VoidCallback? onPressed1,
  VoidCallback? onPressed2,
}) {
  final theme = Theme.of(context);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        alignment: Alignment.center,
        height: 200,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.drag_handle,
                color: theme.disabledColor,
              ),
              Text(
                title,
                style: theme.textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Flexible(
                    child: WideButton(
                      title: text1,
                      onPressed: () {
                        if (onPressed1 != null) {
                          onPressed1();
                        }
                        // auto close
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: WideButton(
                      title: text2,
                      isPositive: false,
                      onPressed: () {
                        if (onPressed2 != null) {
                          onPressed2();
                        }
                        // auto close
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
