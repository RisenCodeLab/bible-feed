import 'package:injectable/injectable.dart';

import '../model/share_dto.dart';
import '../model/virtual_all_done_date.dart';
import '../service/app_service.dart';
import 'feeds_manager.dart';

@lazySingleton
class ShareOutManager(
  final AppService _appService,
  final FeedsManager _feedsManager,
  final VirtualAllDoneDate _virtualAllDoneDate,
) {
  // BEWARE! changing these field names will break share across versions
  String getJson() => ShareDto(
    feedList: _feedsManager.feedManagers.map((fm) => fm.feed).toList(),
    version: _appService.version,
    virtualAllDoneDate: _virtualAllDoneDate.value,
  ).toJson();
}
