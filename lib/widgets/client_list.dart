import 'package:aqua_service2/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom/always_bouncing_scroll_physics.dart';
import 'client_card.dart';

class ClientList extends StatefulWidget {
  const ClientList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  late final SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientBloc = context.read<ClientBloc>();
    if (widget.items.isEmpty) {
      return Center(
        child: Text(
          'Пусто',
          style: theme.textTheme.bodyText1,
        ),
      );
    }
    return ListView.separated(
      physics: const AlwaysBouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.items.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.disabledColor,
          thickness: 1,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Slidable(
          key: Key('${item.id}'),
          controller: slidableController,
          direction: Axis.horizontal,
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ClientCard(
            client: item,
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Удалить',
              color: theme.errorColor,
              icon: Icons.delete,
              onTap: () {
                clientBloc.add(ClientDeleteEvent(item));
                setState(() {
                  widget.items.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
