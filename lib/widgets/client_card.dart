import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:client_repository/client_repository.dart';

import '../services/image_service.dart';
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
    // TODO: it would be nice to add a hero animation for avatar preview
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: FutureBuilder(
            future: ImageService.loadImage(client.avatarPath),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return CircleAvatar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  radius: 45,
                  foregroundImage: MemoryImage(snapshot.data),
                );
              }
              return CircleAvatar(
                backgroundColor: theme.scaffoldBackgroundColor,
                child: Text(
                  client.name.isNotEmpty ? client.name[0] : '?',
                  style: theme.textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: theme.primaryColor,
                  ),
                ),
              );
            },
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
