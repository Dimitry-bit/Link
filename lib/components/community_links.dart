import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityLinks extends StatelessWidget {
  final Map<String, Uri> links;

  const CommunityLinks({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        primary: true,
        child: Row(
          children: links.entries.map((e) {
            return InkWell(
              onTap: () async {
                if (!await launchUrl(e.value)) {
                  SnackBar alert = alertSnackBar(
                    context,
                    "Couldn't launch url.",
                    AlertTypes.error,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(alert);
                }
              },
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: SizedBox.square(
                dimension: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (e.value.toString().contains('drive.google.com'))
                          ? Icons.add_to_drive_rounded
                          : Icons.public,
                      size: 40,
                    ),
                    Text(e.key, style: textStyle),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
