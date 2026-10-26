import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';
import 'popup_verses.dart';

class const PopupBody<T extends PopupManager>({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final popupManager = sl<T>();

    final backgroundColor = popupManager.getBackgroundColor();
    final foregroundColor = popupManager.getForegroundColor();
    final actionButtonSpacing = 4.0;
    final elevation = 8.0;
    final popupAction = popupManager.popupAction;
    final titleFontSize = 24.0;

    return Column(
      mainAxisSize: .min,
      children: [
        Padding(
          padding: Constants.defaultPadding,
          child: Text(
            popupManager.title,
            textAlign: .center,
            style: .new(color: foregroundColor, fontSize: titleFontSize),
          ),
        ),
        Padding(
          padding: Constants.defaultPadding,
          child: Text(
            popupManager.getText(),
            textAlign: .center,
            style: .new(color: foregroundColor),
          ),
        ),
        PopupVerses<T>(),
        if (popupAction != null)
          ElevatedButton(
            key: .new(popupAction.key),
            style: ElevatedButton.styleFrom(
              backgroundColor: foregroundColor,
              foregroundColor: backgroundColor,
              elevation: elevation,
              shape: const RoundedRectangleBorder(borderRadius: .all(Constants.defaultBorderRadius)),
            ),
            onPressed: () {
              popupAction.action();
              Navigator.pop(context);
            },
            child: Row(
              mainAxisSize: .min,
              spacing: actionButtonSpacing,
              // ignore: avoid-non-null-assertion, passed hasAction guard
              children: [Text(popupAction.text), popupAction.icon],
            ),
          ),
      ],
    );
  }
}
