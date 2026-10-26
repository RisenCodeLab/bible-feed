import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'feed.dart';

part 'share_dto.mapper.dart';

@immutable
@MappableClass()
class ShareDto({
  required final String version,
  required final List<Feed> feedList,
  required final DateTime virtualAllDoneDate,
}) with ShareDtoMappable;
