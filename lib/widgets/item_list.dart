import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';
import 'package:order_repository/order_repository.dart';

import 'widgets.dart';

class ItemList extends StatefulWidget {
  const ItemList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late final SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: widget.items.length,
          separatorBuilder: (context, index){
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
              child: ListCard(widget.items[index]),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: theme.errorColor,
                  icon: Icons.delete,
                  onTap: () {
                    _showSnackBar(
                        context, 'Delete', index, widget.items[index]);
                    setState(() {
                      widget.items.removeAt(index);
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackBar(
      BuildContext context, String text, int index, Object item) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          action: SnackBarAction(
            label: 'Отмена',
            onPressed: () {
              setState(() {
                widget.items.insert(index, item);
              });
            },
          ),
        ),
      );
  }
}

class ListCard extends StatelessWidget {
  const ListCard(this.item, {Key? key}) : super(key: key);

  final Object item;

  @override
  Widget build(BuildContext context) {
    if (item is Client) {
      return ClientCard(item as Client);
    } else if (item is Fabric) {
      return const ListTile(
        leading: CircleAvatar(
          child: Text('!'),
        ),
        title: Text('Fabric title'),
        subtitle: Text('Fabric subtitle'),
      );
    } else if (item is Order) {
      return const ListTile(
        leading: CircleAvatar(
          child: Text('!'),
        ),
        title: Text('Order title'),
        subtitle: Text('Order subtitle'),
      );
    } else {
      return const ListTile(
        leading: CircleAvatar(
          child: Text('?'),
        ),
        title: Text('Unknown item'),
        subtitle: Text('???'),
      );
    }
  }
}
