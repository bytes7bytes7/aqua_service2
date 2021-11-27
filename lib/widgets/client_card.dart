import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:client_repository/client_repository.dart';
import 'package:image_repository/image_repository.dart';

import '../blocs/blocs.dart';
import '../constants/tooltips.dart' as constant_tooltips;
import '../constants/sizes.dart' as constant_sizes;
import '../constants/routes.dart' as constant_routes;
import 'ask_bottom_sheet.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    Key? key,
    required this.client,
    required this.controller,
    this.clientNotifier,
    this.isSelected = false,
  }) : super(key: key);

  final Client client;
  final SlidableController controller;
  final ValueNotifier<Client>? clientNotifier;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientBloc = context.read<ClientBloc>();
    // TODO: it would be nice to add a hero animation for avatar preview
    return Slidable(
      key: Key('${client.hashCode}'),
      controller: controller,
      direction: Axis.horizontal,
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        hoverColor: theme.disabledColor,
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
          radius: constant_sizes.avatarRadius + 1,
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
                      radius: constant_sizes.avatarRadius,
                      foregroundImage: MemoryImage(state.avatar),
                    );
                  }
                  return CircleAvatar(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    radius: constant_sizes.avatarRadius,
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
        trailing: (clientNotifier != null && isSelected)
            ? IconButton(
                icon: const Icon(Icons.edit),
                tooltip: constant_tooltips.choose,
                splashRadius: constant_sizes.splashRadius,
                color: theme.primaryColor,
                onPressed: () {
                  // TODO: add navigation to ClientsScreen
                },
              )
            : (clientNotifier == null && client.phone.isNotEmpty)
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
        onTap: () {
          Navigator.of(context).pushNamed(
            constant_routes.clientEdit,
            arguments: {
              'client': client,
            },
          );
        },
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Удалить',
          color: theme.errorColor,
          icon: Icons.delete,
          onTap: () {
            showAskBottomSheet(
              context: context,
              title: 'Вы действительно хотите удалить клиента?',
              text1: 'Отмена',
              text2: 'Удалить',
              onPressed2: () {
                clientBloc.add(ClientDeleteEvent(client));
              },
            );
          },
        ),
      ],
    );
  }
}
