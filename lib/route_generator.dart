import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';

import 'blocs/blocs.dart';
import 'screens/screens.dart';
import 'constants/routes.dart' as constant_routes;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic> args =
        (settings.arguments as Map<String, dynamic>?) ?? {};

    switch (settings.name) {
      case constant_routes.clients:
        return _left(const ClientsScreen());
      case constant_routes.clientEdit:
        Client client = args['client'];
        return _up(
          MultiBlocProvider(
            providers: [
              BlocProvider<AvatarBloc>(
                create: (context) {
                  return AvatarBloc()..add(AvatarLoadEvent(client.avatarPath));
                },
              ),
              BlocProvider<GalleryBloc>(
                create: (context) {
                  return GalleryBloc()..add(GalleryLoadEvent(client.images));
                },
              ),
            ],
            child: ClientEditScreen(client: client),
          ),
        );
      case constant_routes.gallery:
        List<String> images = args['images'];
        int index = args['index'];
        return _up(
          BlocProvider<GalleryBloc>(
            create: (context) {
              return GalleryBloc()..add(GalleryLoadEvent(images));
            },
            child: GalleryScreen(
              images: images,
              index: index,
            ),
          ),
        );
      case constant_routes.fabrics:
        return _left(const FabricsScreen());
      case constant_routes.fabricEdit:
        Fabric? fabric = args['fabric'];
        return _up(
          FabricEditScreen(fabric: fabric ?? Fabric()),
        );
      case constant_routes.about:
        return _left(const AboutScreen());
      default:
        return _left(const NotFoundScreen());
    }
  }

  static Route<dynamic> _left(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          child: child,
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
        );
      },
    );
  }

  static Route<dynamic> _up(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          child: child,
          position: animation.drive(
            Tween(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
        );
      },
    );
  }
}
