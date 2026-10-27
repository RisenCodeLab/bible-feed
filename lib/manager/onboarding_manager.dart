import 'package:injectable/injectable.dart';

import '../service/store_service.dart';

@injectable // must not be a singleton
class OnboardingManager(final StoreService _storeService) {
  String storeKeyFragment = '';

  String get _storeKey => 'hasCompletedOnboarding.$storeKeyFragment';

  bool get isComplete => _storeService.get(_storeKey) ?? false;

  void complete() => _storeService.set(_storeKey, true);
}
