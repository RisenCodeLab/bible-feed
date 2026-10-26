import 'package:flutter/widgets.dart';

import '../model/popup_action.dart';
import '../model/verse.dart';
import '../service/store_service.dart';

abstract class PopupManager(final StoreService _storeService) with ChangeNotifier {
  //// abstract

  Color get backgroundColor;
  Color get foregroundColor;
  String get onboardingStoreKeyFragment;
  PopupAction? get popupAction;
  String get text;
  String get title;

  //// concrete

  String get _onboardingStoreKey => 'hasCompletedOnboarding.$onboardingStoreKeyFragment';
  bool get hasCompletedOnboarding => _storeService.get(_onboardingStoreKey) ?? false;
  List<Verse>? get verses => null;

  void completeOnboarding() => _storeService.set(_onboardingStoreKey, true);

  void show() {
    completeOnboarding();
    notifyListeners();
  }
}
