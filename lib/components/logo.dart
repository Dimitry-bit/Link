import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoStyle = theme.textTheme.displayMedium;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(right: 8.0),
          child: const Icon(Icons.timeline, size: 42),
        ),
        Text('Link', style: logoStyle),
      ],
    );
  }
}
