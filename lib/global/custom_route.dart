import 'package:flutter/material.dart';

Route customRoute(Widget page) {
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
