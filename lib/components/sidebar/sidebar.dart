import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  static const double _defaultWidth = 200;

  final GlobalKey<NavigatorState> navigatorKey;
  final List<Widget> children;
  final double? width;

  const Sidebar(
      {required this.navigatorKey,
      required this.children,
      this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      margin: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          SizedBox(
            width: width ?? _defaultWidth,
            child: ListView(children: children),
          ),
          const VerticalDivider(
            width: 1.0,
            thickness: 2.0,
          ),
        ],
      ),
    );
  }
}
