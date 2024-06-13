import 'package:flutter/material.dart';
import 'package:link/components/sidebar/sidebar.dart';
import 'package:link/routes.dart';

class HomePage extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Sidebar(_navigatorKey),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Navigator(
                key: _navigatorKey,
                onGenerateInitialRoutes: (_, initialRoute) => Routes.generateInitialRoutes(initialRoute),
                onGenerateRoute: (settings) => Routes.generateRoute(settings),
              ),
            ),
          )
        ],
      ),
    );
  }
}
