import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static Uri repositoryLink = Uri.tryParse('https://github.com/Dimitry-bit/link')!;
  static const String aboutText = '''Link is a GPA and schedule management tool.

Designed to streamline your academic life, Link helps you track grades,
manage schedules, and stay organized effortlessly.''';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoStyle = theme.textTheme.displayMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
    final bodyStyle = theme.textTheme.bodyLarge;
    final secondaryStyle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onSecondaryContainer.withOpacity(0.5),
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.timeline, size: 100),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Link', style: logoStyle),
                  Text('Version 1.0', style: secondaryStyle),
                  const SizedBox(height: 16.0),
                  Text(aboutText, style: bodyStyle),
                  const SizedBox(height: 16.0),
                  Text('Developed by Tony Medhat', style: secondaryStyle),
                  const SizedBox(height: 16.0),
                  TextButton.icon(
                    icon: const Icon(Icons.public),
                    label: Text('Source Code', style: secondaryStyle),
                    onPressed: () async => await launchUrl(repositoryLink),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
