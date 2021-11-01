import 'package:flutter/material.dart';

import '../constants/routes.dart' as constant_routes;

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Aqua Service',
                    style: theme.textTheme.headline1!
                        .copyWith(color: theme.scaffoldBackgroundColor),
                  ),
                ],
              ),
            ),
          ),
          ...[
            [Icons.monetization_on, 'Заказы', constant_routes.orders],
            [Icons.people, 'Клиенты', constant_routes.clients],
            [Icons.pan_tool, 'Материалы', constant_routes.fabrics],
            [Icons.report, 'Отчеты', constant_routes.reports],
            [Icons.date_range, 'Календарь', constant_routes.calendar],
            [null],
            [Icons.settings, 'Настройки', constant_routes.settings],
            [Icons.info, 'О приложении', constant_routes.about],
          ].map((entity) {
            if (entity[0] == null) {
              return Divider(
                color: theme.disabledColor,
                thickness: 1,
                height: 1,
              );
            }

            IconData icon = entity[0] as IconData;
            String title = entity[1] as String;
            String route = entity[2] as String;
            return ListTile(
              horizontalTitleGap: 5,
              dense: true,
              leading: Icon(
                icon,
                color: theme.disabledColor,
              ),
              title: Text(
                title,
                style: theme.textTheme.bodyText1,
              ),
              onTap: () {
                // popUntil -> route that doesn't exist
                Navigator.popUntil(context, (route) => route.settings.name == '/');
                Navigator.of(context).pushNamed(route);
              },
            );
          }),
        ],
      ),
    );
  }
}
