import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';
import 'package:order_repository/order_repository.dart';

import 'route_generator.dart';
import 'themes/light_theme.dart';
import 'blocs/blocs.dart';
import 'constants/routes.dart' as constant_routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await SQLiteClientRepository().initTable();
  await SQLiteFabricRepository().initTable();
  await SQLiteOrderRepository().initTable();
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
              SQLiteClientRepository(),
            )..add(ClientLoadEvent());
          },
        ),
        BlocProvider<FabricBloc>(
          create: (context) {
            return FabricBloc(
              SQLiteFabricRepository(),
            )..add(FabricLoadEvent());
          },
        ),
        BlocProvider<OrderBloc>(
          create: (context) {
            return OrderBloc(
              SQLiteOrderRepository(),
            )..add(OrderLoadEvent());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Aqua Service 2',
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: constant_routes.orders,
        onGenerateInitialRoutes: (String? route) {
          return [
            RouteGenerator.generateRoute(
                const RouteSettings(name: constant_routes.orders))
          ];
        },
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
