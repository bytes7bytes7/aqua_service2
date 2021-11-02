import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const DrawerAppBar(title: 'Ошибка'),
      drawer: const AppDrawer(),
      body: Center(
        child: Text(
          'Страница не найдена :(',
          style: theme.textTheme.bodyText1,
        ),
      ),
    );
  }
}
