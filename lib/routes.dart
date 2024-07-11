import 'dart:math';

import 'package:flutter/material.dart';
import 'package:link/screens/courses_page.dart';
import 'package:link/screens/dashboard.dart';
import 'package:link/screens/gpa_page.dart';
import 'package:link/screens/locations_page.dart';
import 'package:link/screens/personnel_page.dart';
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
      case mapPage:
      case viewSchedulesPage:
      case manageSchedulesPage:
        return _createRoute(Placeholder(
          color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
        ));
      case dashboardPage:
        return _createRoute(const Dashboard());
      case gpaPage:
        return _createRoute(const GPAPage());
      case coursesPage:
        return _createRoute(const CoursesPage());
      case locationsPage:
        return _createRoute(const LocationsPage());
      case personnelPage:
        return _createRoute(const PersonnelPage());
      case settingsPage:
        return _createRoute(const SettingsPage());
      default:
        throw const RouteException("Route not found");
    }
  }

  static List<Route> generateInitialRoutes(String name) {
    return [_createRoute(Dashboard())];
  }

  static PageRoute _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      allowSnapshotting: false,
    );
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
