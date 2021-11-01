import 'package:flutter/material.dart';

class PaddingTextFieldNotifier extends StatelessWidget {
  const PaddingTextFieldNotifier({
    Key? key,
    required this.title,
    required this.notifier,
    this.expands = false,
  }) : super(key: key);

  final String title;
  final ValueNotifier<String> notifier;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, String value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 27.0, vertical: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: theme.primaryColor,
              ),
            ),
            child: Text(
              title + ': ' + value,
              style: theme.textTheme.bodyText1!
                  .copyWith(color: theme.primaryColor),
            ),
          ),
        );
      },
    );
  }
}
