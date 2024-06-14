import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_textfield.dart';
import 'package:link/components/page_header.dart';
import 'package:link/models/user_settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final urlController = TextEditingController();
  final linksController = TextEditingController();
  final mapPathsController = TextEditingController();

  @override
  void dispose() {
    urlController.dispose();
    linksController.dispose();
    mapPathsController.dispose();

    super.dispose();
  }

  void _setControllers(UserSettings userSettings) {
    urlController.clear();
    linksController.clear();
    mapPathsController.clear();

    urlController.text = userSettings.upstreamUrl.toString();
    linksController.text = userSettings
        .communityLinks()
        .map((e) => "${e.key}, ${e.value}")
        .join('\n');
    mapPathsController.text =
        userSettings.mapPaths().map((path) => path.toString()).join(',\n');
  }

  void _submit(BuildContext context, UserSettings userSettings) {
    userSettings.setMapPaths(mapPathsController.text);
    String errorStr = '';

    if (!userSettings.setUpstreamUrl(urlController.text)) {
      errorStr += 'Upstream';
    }

    if (!userSettings.setCommunityLinks(linksController.text)) {
      if (errorStr.isNotEmpty) {
        errorStr += ' and ';
      }

      errorStr += 'Community Links';
    }

    if (errorStr.isNotEmpty) {
      final alert =
          alertSnackBar(context, 'Invalid $errorStr.', AlertTypes.error);
      ScaffoldMessenger.of(context).showSnackBar(alert);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    UserSettings userSettings = Provider.of<UserSettings>(context);
    _setControllers(userSettings);

    return Center(
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            const PageHeader(title: 'Settings'),
            OutlinedTextFieldForm(
              controller: urlController,
              labelText: 'Upstream URL',
              maxLines: 1,
            ),
            const Divider(),
            OutlinedTextFieldForm(
              controller: linksController,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
              labelText: 'Community Links',
              hintText: 'example, https://example.com/',
              alignLabelWithHint: true,
            ),
            const Divider(),
            OutlinedTextFieldForm(
              controller: mapPathsController,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
              labelText: 'Map Images',
              hintText: 'floor1.png',
              alignLabelWithHint: true,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _setControllers(userSettings),
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    side: BorderSide(
                      width: 1.0,
                      color: colorScheme.primary,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _submit(context, userSettings),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: const Text('Save'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
