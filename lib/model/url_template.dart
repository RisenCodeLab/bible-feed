import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class UrlTemplate extends DelegatingMap<TargetPlatform, String> {
  // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
  UrlTemplate(String urlTemplate) : super({.android: urlTemplate, .iOS: urlTemplate});

  UrlTemplate.byPlatform({required String android, required String iOS})
    // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
    : super({.android: android, .iOS: iOS});
}

