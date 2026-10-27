import 'package:flutter/widgets.dart';

import '../model/popup_action.dart';
import '../model/verse.dart';
import 'onboarding_manager.dart';

abstract class PopupManager(final OnboardingManager onboardingManager) with ChangeNotifier {
  /// abstract

  Color get backgroundColor;
  Color get foregroundColor;
  PopupAction? get popupAction;
  String get text;
  String get title;

  /// concrete

  List<Verse>? get verses => null;

  void show() {
    onboardingManager.completeOnboarding();
    notifyListeners();
  }
}
