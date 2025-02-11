import 'package:flutter/material.dart';
import 'package:pope_desktop/core/routing/routes.dart';
import 'package:pope_desktop/features/explorer/presentaion/screens/explorer_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings routeSettings) {
    // final arguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.explorerScreen:
        return MaterialPageRoute(
          builder: (_) => const ExplorerScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
