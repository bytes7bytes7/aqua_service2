import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  DrawerAppBar(title: 'Страница не найдена'),
      drawer:  AppDrawer(),
      body: Center(
        child:  Text('Стриница не найдена :('),
      ),
    );
  }
}
