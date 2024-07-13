import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/components/rectangle_elevated_button.dart';
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

  @override
  void dispose() {
    urlController.dispose();
    linksController.dispose();

    super.dispose();
  }

  void _setControllers(UserSettings userSettings) {
    urlController.clear();
    linksController.clear();

    urlController.text = userSettings.upstreamUrl.toString();
    linksController.text = userSettings
        .communityLinks()
        .entries
        .map((e) => "${e.key}, ${e.value}")
        .join('\n');
  }

  void _submit(BuildContext context, UserSettings userSettings) {
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
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedTextButton(
                  onPressed: () => _setControllers(userSettings),
                  text: 'Cancel',
                ),
                const SizedBox(width: 8.0),
                RectangleElevatedButton(
                  onPressed: () => _submit(context, userSettings),
                  text: 'Save',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
