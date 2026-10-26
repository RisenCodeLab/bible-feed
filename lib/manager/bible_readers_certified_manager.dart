import 'package:dartx/dartx.dart';
import 'package:injectable/injectable.dart';

import '../model/bible_reader.dart';
import '../model/bible_readers.dart';
import '../service/platform_service.dart';

@lazySingleton
class BibleReadersCertifiedManager(BibleReaders bibleReaders, PlatformService platformService) {
  final List<BibleReader> _certifiedBibleReaderList = bibleReaders
      .filter((br) => br.certifiedPlatforms.contains(platformService.currentPlatform))
      .toList();

  List<BibleReader> get certifiedBibleReaderList => _certifiedBibleReaderList;
}
