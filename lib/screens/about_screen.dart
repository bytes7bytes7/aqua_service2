import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const url = 'https://github.com/bytes7bytes7';
    return Scaffold(
      appBar: const DrawerAppBar(title: 'О приложении'),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Приложение создано на Flutter 2.5.3 с использованием bloc 7.2.1 в 2021 году.'
              '\n\nРазработчик: bytes7bytes7',
              style: theme.textTheme.bodyText1,
            ),
            InkWell(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Github: ',
                      style: theme.textTheme.bodyText1,
                    ),
                    TextSpan(
                      text: url,
                      style: theme.textTheme.bodyText1!
                          .copyWith(color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
              onTap: () => url_launcher.launch(url),
            ),
          ],
        ),
      ),
    );
  }
}
