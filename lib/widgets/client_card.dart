import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:client_repository/client_repository.dart';

import '../constants/tooltips.dart' as constant_tooltips;
import '../constants/sizes.dart' as constant_sizes;
import '../constants/routes.dart' as constant_routes;

class ClientCard extends StatelessWidget {
  const ClientCard({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            backgroundColor: theme.scaffoldBackgroundColor,
            child: Text(
              client.name.isNotEmpty ? client.name[0] : '?',
              style: theme.textTheme.headline2!.copyWith(
                fontWeight: FontWeight.normal,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        client.name,
        style: theme.textTheme.headline2,
      ),
      subtitle: Text(
        client.city,
        style: theme.textTheme.subtitle1,
      ),
      trailing: client.phone.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.phone),
              tooltip: constant_tooltips.call,
              splashRadius: constant_sizes.splashRadius,
              color: theme.primaryColor,
              onPressed: () {
                url_launcher.launch("tel://${client.phone}");
              },
            )
          : const SizedBox.shrink(),
      hoverColor: theme.disabledColor,
      onTap: () {
        Navigator.of(context).pushNamed(
          constant_routes.clientEdit,
          arguments: {
            'client': client,
          },
        );
      },
    );
  }
}
