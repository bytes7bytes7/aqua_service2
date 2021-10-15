import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../blocs/blocs.dart';
import 'client_card.dart';

class ClientList extends StatefulWidget {
  const ClientList({
    Key? key,
    required this.items,
    required this.onAdd,
    required this.onUpdate,
  }) : super(key: key);

  final List items;
  final Function onAdd;
  final Function onUpdate;

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
    return ListView.separated(
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
            client: widget.items[index],
            onAdd: widget.onAdd,
            onUpdate: widget.onUpdate,
          ),
          secondaryActions: <Widget>[
            BlocBuilder<ClientBloc, ClientState>(
                builder: (BuildContext context, ClientState state) {
              return IconSlideAction(
                caption: 'Удалить',
                color: theme.errorColor,
                icon: Icons.delete,
                onTap: () {
                  context
                      .read<ClientBloc>()
                      .add(ClientDeleteEvent(widget.items[index]));
                  setState(() {
                    widget.items.removeAt(index);
                  });
                },
              );
            }),
          ],
        );
      },
    );
  }
}
