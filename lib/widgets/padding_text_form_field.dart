import 'package:flutter/material.dart';

import '../constants.dart';

typedef OnSaveCallback = void Function(String?);

class PaddingTextFormField extends StatelessWidget {
  const PaddingTextFormField({
    Key? key,
    required this.title,
    required this.value,
    required this.onSave,
    this.onPressed,
    this.keyboardType = TextInputType.name,
    this.expands = false,
  }) : super(key: key);

  final String title;
  final String? value;
  final OnSaveCallback onSave;
  final VoidCallback? onPressed;
  final TextInputType keyboardType;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
      child: TextFormField(
        controller: TextEditingController(text: value),
        cursorColor: theme.primaryColor,
        style: theme.textTheme.bodyText1,
        textAlignVertical: TextAlignVertical.top,
        expands: expands,
        maxLines: expands ? null : 1,
        keyboardType: keyboardType,
        onSaved: onSave,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 27.0, vertical: 16.0),
          labelText: title,
          alignLabelWithHint: true,
          labelStyle:
              theme.textTheme.bodyText1!.copyWith(color: theme.disabledColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(35),
          ),
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
