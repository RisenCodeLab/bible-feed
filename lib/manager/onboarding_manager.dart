import 'package:injectable/injectable.dart';

import '../service/store_service.dart';

@injectable // must not be a singleton
class OnboardingManager(final StoreService _storeService) {
  String onboardingStoreKeyFragment = '';

  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKeyFragment';
  bool get hasCompletedOnboarding => _storeService.get(_onboardingStoreKey) ?? false;
  void completeOnboarding() => _storeService.set(_onboardingStoreKey, true);
}
