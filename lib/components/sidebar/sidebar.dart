import 'package:flutter/material.dart';
import 'package:link/components/logo.dart';
import 'package:link/components/sidebar/sidebar_destination.dart';
import 'package:link/routes.dart';

class Sidebar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Sidebar(this.navigatorKey, {super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String selectedRoute = '/';

  SidebarDestination _buildDestination(
    String label, {
    IconData? icon,
    String? route,
    bool selectable = true,
  }) {
    return SidebarDestination(
      label: label,
      icon: (icon != null) ? icon : null,
      selected: (selectable) ? selectedRoute == route : false,
      onTap: (route != null)
          ? () {
              widget.navigatorKey.currentState!.pushNamed(route);
              setState(() {
                selectedRoute = route;
              });
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)
      ),
      margin: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: ListView(
              children: <Widget>[
                const Logo(),
                _buildDestination('View'),
                _buildDestination('Dashboard', icon: Icons.home, route: Routes.dashboardPage),
                _buildDestination('Schedules', icon: Icons.calendar_today, route: Routes.viewSchedulesPage),
                _buildDestination('GPA', icon: Icons.percent, route: Routes.gpaPage),
                _buildDestination('Map', icon: Icons.map, route: Routes.mapPage),
                const Divider(),
                _buildDestination('Manage'),
                _buildDestination('Course', icon: Icons.book, route: Routes.coursesPage),
                _buildDestination('Doctors/TAs', icon: Icons.person_2, route: Routes.personnelPage),
                _buildDestination('Locations', icon: Icons.location_pin, route: Routes.locationsPage),
                _buildDestination('Schedules', icon: Icons.calendar_today, route: Routes.manageSchedulesPage),
                const Divider(),
                _buildDestination('Settings', icon: Icons.settings, route: Routes.settingsPage),
                _buildDestination('About', icon: Icons.info),
              ],
            ),
          ),
          const VerticalDivider(width: 1.0, thickness: 2.0,),
        ],
      ),
    );
  }
}
