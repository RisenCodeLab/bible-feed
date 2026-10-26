import '../service/store_service.dart';

abstract class OnboardingManager(final StoreService _storeService) {
  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKeyFragment';

  String get onboardingStoreKeyFragment;

  bool get hasCompletedOnboarding => _storeService.get(_onboardingStoreKey) ?? false;

  void completeOnboarding() => _storeService.set(_onboardingStoreKey, true);
}
