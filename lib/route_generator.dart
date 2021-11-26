import 'package:flutter/material.dart';

import 'screens/screens.dart';
import 'constants/routes.dart' as constant_routes;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic> args =
        (settings.arguments as Map<String, dynamic>?) ?? {};

    switch (settings.name) {
      case constant_routes.orders:
        return _left(const OrdersScreen());
      case constant_routes.orderEdit:
        return _up(
          OrderEditScreen(order: args['order']),
        );
      case constant_routes.clients:
        return _left(const ClientsScreen());
      case constant_routes.clientEdit:
        return _up(
          ClientEditScreen(client: args['client']),
        );
      case constant_routes.gallery:
        return _up(
          GalleryScreen(
            galleryBloc: args['galleryBloc'],
            images: args['images'],
            index: args['index'],
          ),
        );
      case constant_routes.fabrics:
        return _left(
          FabricsScreen(
            fabricsNotifier: args['fabricsNotifier'],
          ),
        );
      case constant_routes.fabricEdit:
        return _up(
          FabricEditScreen(fabric: args['fabric']),
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
      // false for avatar preview
      // opaque: false,
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
