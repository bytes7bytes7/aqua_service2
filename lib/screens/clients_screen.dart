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
            return ItemList(items: state.clients);
          } else if (state is ClientErrorState) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: theme.primaryColor,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ERROR',
                      style: theme.textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        children: [
                          Text(state.error),
                        ],
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Скопировать',
                        style: theme.textTheme.subtitle1!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text(
                        'Попробовать снова',
                        style: theme.textTheme.subtitle1!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        context.read<ClientBloc>().add(ClientLoadEvent());
                      },
                    ),
                  ],
                ),
              ),
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
