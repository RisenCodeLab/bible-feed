import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../manager/feed_manager.dart';

part 'share_dto.mapper.dart';

@immutable
@MappableClass()
class ShareDto with ShareDtoMappable {
  ShareDto({required this.buildNumber, required this.feedStateList, required this.virtualAllDoneDate});

  final String buildNumber;
  final List<Feed> feedStateList;
  final DateTime virtualAllDoneDate;
}
