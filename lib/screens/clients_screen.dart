import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import '../widgets/widgets.dart';
import '../blocs/blocs.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: const Text('Клиенты'),
      ),
      drawer: const Drawer(),
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (BuildContext context, ClientState state) {
          if (state is ClientLoadingState) {
            return const LoadingCircle();
          } else if (state is ClientDataState) {
            return ClientList(items: state.clients);
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
                context.read<ClientBloc>().add(ClientAddEvent(Client()));
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