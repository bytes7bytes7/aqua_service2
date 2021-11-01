import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../constants/sizes.dart' as constant_sizes;
import '../constants/tooltips.dart' as constant_tooltips;

typedef OnSaveCallback = void Function(String?);
typedef ValidatorCallback = String? Function(String?);

class PaddingTextFormField extends StatefulWidget {
  const PaddingTextFormField({
    Key? key,
    required this.title,
    required this.value,
    required this.onSave,
    this.validator,
    this.isPhoneNumber = false,
    this.keyboardType = TextInputType.name,
    this.expands = false,
  }) : super(key: key);

  final String title;
  final String? value;
  final OnSaveCallback onSave;
  final ValidatorCallback? validator;
  final bool isPhoneNumber;
  final TextInputType keyboardType;
  final bool expands;

  @override
  State<PaddingTextFormField> createState() => _PaddingTextFormFieldState();
}

class _PaddingTextFormFieldState extends State<PaddingTextFormField> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
      child: TextFormField(
        controller: controller,
        cursorColor: theme.primaryColor,
        style: theme.textTheme.bodyText1,
        textAlignVertical: TextAlignVertical.top,
        expands: widget.expands,
        maxLines: widget.expands ? null : 1,
        keyboardType: widget.keyboardType,
        onSaved: widget.onSave,
        validator: widget.validator,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 27.0, vertical: 16.0),
          labelText: widget.title,
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
          suffixIcon: widget.isPhoneNumber
              ? Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.call),
                    color: theme.primaryColor,
                    tooltip: constant_tooltips.call,
                    splashRadius: constant_sizes.splashRadius,
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        url_launcher.launch("tel://${controller.text}");
                      }
                    },
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
