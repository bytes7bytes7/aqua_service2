import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    Key? key,
    this.isPositive = true,
    required this.title,
    this.isActive = true,
    required this.onPressed,
  }) : super(key: key);

  final bool isPositive;
  final String title;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isPositive
        ? theme.primaryColor.withOpacity(isActive ? 1 : 0.4)
        : theme.errorColor.withOpacity(isActive ? 1 : 0.4);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        child: Text(
          title,
          style: theme.textTheme.headline2!.copyWith(color: color),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          primary: color,
          side: BorderSide(
            color: color,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
        onPressed: isActive ? onPressed : null,
      ),
    );
  }
}
