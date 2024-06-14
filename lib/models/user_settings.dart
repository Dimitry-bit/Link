import 'dart:collection';

import 'package:flutter/material.dart';

class UserSettings extends ChangeNotifier {
  Uri _upstreamUrl = Uri();
  LinkedHashMap<String, Uri> _communityLinks = LinkedHashMap();
  List<String> _mapPaths = List.empty();

  Uri get upstreamUrl {
    return _upstreamUrl;
  }

  Iterable<MapEntry<String, Uri>> communityLinks() {
    return _communityLinks.entries;
  }

  Iterable<String> mapPaths() {
    return _mapPaths;
  }

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

  void setMapPaths(String paths) {
    String pathsTrimmed = paths.trim();
    _mapPaths = pathsTrimmed.split('\n');
    notifyListeners();
  }
}
