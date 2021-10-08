import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aqua_service2/blocs/blocs.dart';

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
            return const CircularProgressIndicator();
          } else if (state is ClientDataState) {
            return Column(
              children: [
                ...state.clients.map((e) {
                  return Text('${e.name} ${e.city}');
                }).toList(),
                TextButton(
                  child: const Text('Refresh'),
                  onPressed: () {
                    context.read<ClientBloc>().add(ClientLoadEvent());
                  },
                ),
              ],
            );
          } else if (state is ClientErrorState) {
            return Column(
              children: [
                Text('Error: ${state.error}'),
                TextButton(
                  child: const Text('Refresh'),
                  onPressed: () {
                    context.read<ClientBloc>().add(ClientLoadEvent());
                  },
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
