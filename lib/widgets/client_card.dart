import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:client_repository/client_repository.dart';
import 'package:image_repository/image_repository.dart';

import '../blocs/blocs.dart';
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
          child: BlocProvider<AvatarBloc>(
            create: (context) {
              return AvatarBloc(const ImageRepository())
                ..add(AvatarLoadEvent(client.avatarPath));
            },
            child: BlocBuilder<AvatarBloc, AvatarState>(
              builder: (BuildContext context, AvatarState state) {
                if (state is AvatarDataState && state.avatar.isNotEmpty) {
                  return CircleAvatar(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    radius: 45,
                    foregroundImage: MemoryImage(state.avatar),
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
