import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import 'custom/route_generator.dart';
import 'themes/light_theme.dart';
import 'blocs/blocs.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await const SQLiteClientRepository().initTable();
  // await const SQLiteFabricRepository().initTable();
  // await const SQLiteOrderRepository().initTable();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: try it
    // // Need to: import 'package:flutter/services.dart';
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.purple,
    // ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClientBloc>(
          create: (context) {
            return ClientBloc(
              clientRepository: const SQLiteClientRepository(),
            )..add(ClientLoadEvent());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Aqua Service 2',
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: ConstantRoutes.clients,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
