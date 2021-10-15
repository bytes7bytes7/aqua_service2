import 'package:flutter/material.dart';
import 'package:client_repository/client_repository.dart';

class ClientCard extends StatelessWidget {
  const ClientCard(this.client, {Key? key}) : super(key: key);

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
              color: theme.primaryColor,
              onPressed: () {},
            )
          : const SizedBox.shrink(),
      hoverColor: theme.disabledColor,
      onTap: () {
        Navigator.of(context).pushNamed('/clients/edit');
      },
    );
  }
}
