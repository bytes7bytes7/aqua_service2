import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    required this.error,
    required this.onRefresh,
  }) : super(key: key);

  final String error;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: theme.primaryColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка',
              style: theme.textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView(
                children: [
                  Text(error),
                ],
              ),
            ),
            TextButton(
              child: Text(
                'Скопировать',
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // TODO: add copy function
              },
            ),
            TextButton(
              child: Text(
                'Попробовать снова',
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}
