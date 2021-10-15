import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import '../global/custom_route.dart';
import '../widgets/widgets.dart';
import '../blocs/blocs.dart';
import 'client_edit_screen.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onAdd(Client client) {
      context.read<ClientBloc>().add(ClientAddEvent(client));
    }

    void onUpdate(Client client) {
      context.read<ClientBloc>().add(ClientUpdateEvent(client));
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: const DrawerAppBar(title: 'Клиенты'),
      drawer: const AppDrawer(),
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (BuildContext context, ClientState state) {
          if (state is ClientLoadingState) {
            return const LoadingCircle();
          } else if (state is ClientDataState) {
            return ClientList(
              items: state.clients,
              onAdd: onAdd,
              onUpdate: onUpdate,
            );
          } else if (state is ClientErrorState) {
            return ErrorCard(
              error: state.error,
              onRefresh: () {
                context.read<ClientBloc>().add(ClientLoadEvent());
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
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  customRoute(
                    ClientEditScreen(
                      client: Client(),
                      onAdd: onAdd,
                      onUpdate: onUpdate,
                    ),
                  ),
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
