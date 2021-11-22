import 'package:flutter/material.dart';

import '../constants/sizes.dart' as constant_sizes;

class FloatingLabelContainer extends StatelessWidget {
  const FloatingLabelContainer({
    Key? key,
    required this.text,
    required this.style,
    required this.borderColor,
    required this.backgroundColor,
    required this.padding,
    required this.child,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: padding,
            margin: EdgeInsets.symmetric(
                vertical: style.fontSize != null ? style.fontSize! / 3 : 5),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(constant_sizes.borderRadius),
                side: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            child: child,
          ),
          Positioned(
            top: 0,
            left: constant_sizes.textFieldHorPadding / 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: backgroundColor,
              child: Text(
                text,
                style: style.copyWith(fontSize: style.fontSize! / 1.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
