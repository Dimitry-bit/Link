import 'package:flutter/material.dart';
import 'package:link/components/community_links.dart';
import 'package:link/components/gpa_gauge.dart';
import 'package:link/components/page_header.dart';
import 'package:link/models/user_settings.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context);

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const PageHeader(title: 'Dashboard'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PageHeader(title: 'Links'),
                        CommunityLinks(links: userSettings.communityLinks()),
                      ],
                    ),
                  ),
                ),
              ),
              const GPAGauge(),
            ],
          ),
        ],
      ),
    );
  }
}
