import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class UrlTemplate.byPlatform({required String android, required String iOS})
    extends DelegatingMap<TargetPlatform, String> {
  // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
  this : super({.android: android, .iOS: iOS});

  // ignore: avoid-missing-enum-constant-in-map, other platforms are not supported
  new(String urlTemplate) : this.byPlatform(android: urlTemplate, iOS: urlTemplate);
}
