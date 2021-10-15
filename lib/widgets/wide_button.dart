import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    Key? key,
    this.isPositive = true,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final bool isPositive;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        child: Text(
          title,
          style: theme.textTheme.headline2!.copyWith(
              color: isPositive ? theme.primaryColor : theme.errorColor),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          primary: isPositive ? theme.primaryColor : theme.errorColor,
          side: BorderSide(
            color: isPositive ? theme.primaryColor : theme.errorColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
