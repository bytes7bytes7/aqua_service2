import 'package:flutter/material.dart';

import '../constants.dart';

class PaddingTextFormField extends StatelessWidget {
  const PaddingTextFormField({
    Key? key,
    required this.title,
    this.onPressed,
    this.expands = false,
  }) : super(key: key);

  final String title;
  final VoidCallback? onPressed;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
      child: TextFormField(
        style: theme.textTheme.bodyText1,
        textAlignVertical: TextAlignVertical.top,
        expands: expands,
        maxLines: expands ? null : 1,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 27.0, vertical: 16.0),
          labelText: title,
          alignLabelWithHint: true,
          labelStyle:
              theme.textTheme.bodyText1!.copyWith(color: theme.disabledColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.disabledColor,
            ),
            borderRadius: BorderRadius.circular(35),
          ),
          suffixIcon: onPressed != null
              ? Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.call),
                    color: theme.primaryColor,
                    tooltip: ConstantTooltips.call,
                    splashRadius: ConstantSizes.splashRadius,
                    onPressed: onPressed,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
