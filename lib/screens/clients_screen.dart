import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import '../widgets/widgets.dart';
import '../blocs/blocs.dart';
import '../constants/routes.dart' as constant_routes;
import '../constants/tooltips.dart' as constant_tooltips;

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientBloc = context.read<ClientBloc>();
    return Scaffold(
      appBar: const DrawerAppBar(title: 'Клиенты'),
      drawer: const AppDrawer(),
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (BuildContext context, ClientState state) {
          if (state is ClientLoadingState) {
            return const LoadingCircle();
          } else if (state is ClientDataState) {
            return _ClientList(
              items: state.clients,
            );
          } else if (state is ClientErrorState) {
            return ErrorCard(
              error: state.error,
              onRefresh: () {
                clientBloc.add(ClientLoadEvent());
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: BlocBuilder<ClientBloc, ClientState>(
        builder: (BuildContext context, ClientState state) {
          if (state is ClientDataState) {
            return FloatingActionButton(
              tooltip: constant_tooltips.add,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  constant_routes.clientEdit,
                  arguments: {
                    'client': Client(),
                  },
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ClientList extends StatefulWidget {
  const _ClientList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  __ClientListState createState() => __ClientListState();
}

class __ClientListState extends State<_ClientList> {
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
      physics: const BouncingScrollPhysics(),
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
          key: Key('${item.hashCode}'),
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
