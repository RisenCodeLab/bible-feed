import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../model/bible_reader.dart';
import '../model/bible_reader_key.dart';
import '../service/store_service.dart';
import 'bible_readers_certified_manager.dart';

@lazySingleton
class BibleReaderLinkManager(
  final BibleReadersCertifiedManager _bibleReadersCertifiedManager,
  final StoreService _storeService,
) with ChangeNotifier {
  this {
    _loadState();
  }

  late BibleReaderKey _linkedBibleReaderKey; // ignore: avoid-late-keyword, guaranteed to be set in ctor -> _loadState
  static const _linkedBibleReaderStoreKey = 'linkedBibleReader';

  List<BibleReader> get _certifiedBibleReaderList => _bibleReadersCertifiedManager.certifiedBibleReaderList;

  void _loadState() {
    try {
      final String? linkedReaderName = _storeService.get(_linkedBibleReaderStoreKey);
      _linkedBibleReaderKey = BibleReaderKey.values.byName(linkedReaderName ?? BibleReaderKey.none.name);
      linkedBibleReader; // throws an exception if linkedBibleReader is invalid or uncertified
    } catch (_) {
      _linkedBibleReaderKey = .none;
    }
  }

  void _saveState(BibleReaderKey value) {
    if (value == _linkedBibleReaderKey) return;
    _linkedBibleReaderKey = value;
    _storeService.set(_linkedBibleReaderStoreKey, value.name);
    notifyListeners();
  }

  bool get isLinked => _linkedBibleReaderKey != .none;
  BibleReader get linkedBibleReader => _certifiedBibleReaderList.firstWhere((e) => e.key == _linkedBibleReaderKey);
  int get linkedBibleReaderIndex => _certifiedBibleReaderList.indexOf(linkedBibleReader);
  set linkedBibleReaderIndex(int value) => _saveState(_certifiedBibleReaderList[value].key);

  void unlinkBibleReader() => _saveState(.none);
}
