import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;
  final Icon? icon;
  final TextStyle? style;

  const Logo({required this.title, this.icon, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoStyle = theme.textTheme.displayMedium;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(right: 8.0),
          child: icon,
        ),
        Text(title, style: style ?? logoStyle),
      ],
    );
  }
}
