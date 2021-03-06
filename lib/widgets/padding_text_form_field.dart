import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../constants/sizes.dart' as constant_sizes;
import '../constants/tooltips.dart' as constant_tooltips;

typedef VoidStringCallBack = void Function(String);
typedef ValidatorCallback = String? Function(String?);

enum SuffixIconType {
  none,
  phone,
  calendar,
}

class PaddingTextFormField extends StatefulWidget {
  const PaddingTextFormField({
    Key? key,
    required this.title,
    required this.value,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.name,
    this.suffixIconType = SuffixIconType.none,
    this.expands = false,
  }) : super(key: key);

  final String title;
  final String? value;
  final ValidatorCallback? validator;
  final VoidStringCallBack? onChanged;
  final TextInputType keyboardType;
  final SuffixIconType suffixIconType;
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
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
      child: TextFormField(
        controller: controller,
        cursorColor: theme.primaryColor,
        style: theme.textTheme.bodyText1,
        textAlignVertical: TextAlignVertical.top,
        expands: widget.expands,
        maxLines: widget.expands ? null : 1,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: constant_sizes.textFieldHorPadding,
              vertical: constant_sizes.textFieldVerPadding),
          labelText: widget.title,
          alignLabelWithHint: true,
          labelStyle:
              theme.textTheme.bodyText1!.copyWith(color: theme.disabledColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.disabledColor,
            ),
            borderRadius: BorderRadius.circular(constant_sizes.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(constant_sizes.borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.disabledColor,
            ),
            borderRadius: BorderRadius.circular(constant_sizes.borderRadius),
          ),
          suffixIcon: (widget.suffixIconType == SuffixIconType.phone)
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
              : (widget.suffixIconType == SuffixIconType.calendar)
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: const Icon(Icons.date_range),
                        color: theme.primaryColor,
                        tooltip: constant_tooltips.calendar,
                        splashRadius: constant_sizes.splashRadius,
                        onPressed: () {
                          // TODO: add navigation to CalendarScreen
                        },
                      ),
                    )
                  : null,
        ),
      ),
    );
  }
}
