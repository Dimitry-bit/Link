import 'dart:math';

import 'package:flutter/material.dart';
import 'package:link/screens/settings_page.dart';

class Routes {
  static const String dashboardPage = '/';
  static const String gpaPage = '/gpa';
  static const String mapPage = '/map';
  static const String viewSchedulesPage = '/schedules';

  static const String coursesPage = '/courses';
  static const String locationsPage = '/locations';
  static const String personnelPage = '/personnel';
  static const String manageSchedulesPage = '/schedules_editor';

  static const String settingsPage = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardPage:
      case gpaPage:
      case mapPage:
      case viewSchedulesPage:
      case coursesPage:
      case locationsPage:
      case personnelPage:
      case manageSchedulesPage:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => Placeholder(
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0)),
        );
      case settingsPage:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => SettingsPage());
      default:
        throw const RouteException("Route not found");
    }
  }

  static List<Route> generateInitialRoutes(String name) {
    return <Route>[MaterialPageRoute(builder: (_) => const Placeholder())];
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
