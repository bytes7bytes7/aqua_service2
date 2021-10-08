import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import 'screens/clients_screen.dart';
import 'themes/light_theme.dart';
import 'blocs/blocs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ClientBloc(clientRepository: SQLiteClientRepository())
              ..add(ClientLoadEvent());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Aqua Service 2',
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/clients',
        routes: {
          '/clients': (context) => const ClientsScreen(),
        },
      ),
    );
  }
}
