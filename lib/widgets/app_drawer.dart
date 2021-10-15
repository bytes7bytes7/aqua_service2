import 'package:flutter/material.dart';

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
            [Icons.monetization_on, 'Заказы', () {}],
            [Icons.people, 'Клиенты', () {}],
            [Icons.pan_tool, 'Материалы', () {}],
            [Icons.report, 'Отчеты', () {}],
            [Icons.date_range, 'Календарь', () {}],
          ].map((entity) {
            IconData icon = entity[0] as IconData;
            String title = entity[1] as String;
            VoidCallback onTap = entity[2] as VoidCallback;

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
              onTap: onTap,
            );
          }),
          Divider(
            color: theme.disabledColor,
            thickness: 1,
            height: 1,
          ),
          ...[
            [Icons.settings, 'Настройки', () {}],
            [Icons.info, 'О приложении', () {}],
          ].map((entity) {
            IconData icon = entity[0] as IconData;
            String title = entity[1] as String;
            VoidCallback onTap = entity[2] as VoidCallback;

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
              onTap: onTap,
            );
          }),
        ],
      ),
    );
  }
}
