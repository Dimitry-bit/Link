import 'dart:collection';

import 'package:flutter/material.dart';

class UserSettings extends ChangeNotifier {
  Uri _upstreamUrl = Uri();
  Map<String, Uri> _communityLinks = {};

  Uri get upstreamUrl => _upstreamUrl;

  Map<String, Uri> communityLinks() => _communityLinks;

  bool setUpstreamUrl(String upstreamUrl) {
    String trimmedUpstream = upstreamUrl.trim();

    if (trimmedUpstream.isEmpty) {
      _upstreamUrl = Uri();
      return true;
    }

    Uri? uri = Uri.tryParse(trimmedUpstream);
    bool isValidUrl = uri?.hasAbsolutePath ?? false;

    if (!isValidUrl) {
      return false;
    }

    _upstreamUrl = uri!;
    notifyListeners();

    return true;
  }

  bool setCommunityLinks(String links) {
    String linksTrimmed = links.trim();

    if (linksTrimmed.isEmpty) {
      _communityLinks.clear();
      return true;
    }

    LinkedHashMap<String, Uri> map = LinkedHashMap();
    List<String> linkEntries = linksTrimmed.split('\n');
    for (String linkEntry in linkEntries) {
      List<String> entry = linkEntry.split(',');

      if (entry.length != 2) {
        return false;
      }

      String label = entry.first.trim();
      Uri? uri = Uri.tryParse(entry.last.trim());
      bool isValidUrl = uri?.hasAbsolutePath ?? false;

      if (label.isEmpty || !isValidUrl) {
        return false;
      }

      map[label] = uri!;
    }
    _communityLinks = map;
    notifyListeners();

    return true;
  }
}
