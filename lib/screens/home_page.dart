import 'package:flutter/material.dart';
import 'package:link/components/logo.dart';
import 'package:link/components/sidebar/sidebar.dart';
import 'package:link/components/sidebar/sidebar_destination.dart';
import 'package:link/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  String _selectedRoute = '/';

  SidebarDestination _buildDestination(
    String label, {
    IconData? icon,
    String? route,
    bool selectable = true,
  }) {
    return SidebarDestination(
      label: label,
      icon: (icon != null) ? icon : null,
      selected: (selectable) ? _selectedRoute == route : false,
      onTap: (route != null)
          ? () {
              _navigatorKey.currentState!.popAndPushNamed(route);
              setState(() {
                _selectedRoute = route;
              });
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Sidebar(
            navigatorKey: _navigatorKey,
            children: [
              const Logo(
                title: 'Link',
                icon: Icon(Icons.timeline, size: 42),
              ),
              _buildDestination('View'),
              _buildDestination(
                'Dashboard',
                icon: Icons.home,
                route: Routes.dashboardPage,
              ),
              _buildDestination(
                'Schedules',
                icon: Icons.calendar_today,
                route: Routes.viewSchedulesPage,
              ),
              _buildDestination(
                'GPA',
                icon: Icons.percent,
                route: Routes.gpaPage,
              ),
              const Divider(),
              _buildDestination('Manage'),
              _buildDestination(
                'Course',
                icon: Icons.book,
                route: Routes.coursesPage,
              ),
              _buildDestination(
                'Doctors/TAs',
                icon: Icons.person_2,
                route: Routes.personnelPage,
              ),
              _buildDestination(
                'Locations',
                icon: Icons.location_pin,
                route: Routes.locationsPage,
              ),
              _buildDestination(
                'Schedules',
                icon: Icons.calendar_today,
                route: Routes.manageSchedulesPage,
              ),
              const Divider(),
              _buildDestination(
                'Settings',
                icon: Icons.settings,
                route: Routes.settingsPage,
              ),
              _buildDestination(
                'About',
                icon: Icons.info,
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: Navigator(
                key: _navigatorKey,
                onGenerateInitialRoutes: (_, initialRoute) =>
                    Routes.generateInitialRoutes(initialRoute),
                onGenerateRoute: (settings) => Routes.generateRoute(settings),
              ),
            ),
          )
        ],
      ),
    );
  }
}
