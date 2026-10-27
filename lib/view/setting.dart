import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../model/setting.dart' as model;
import '_constants.dart';

class Setting<T extends model.Setting> extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final setting = watchIt<T>();

    return Opacity(
      opacity: setting.isAvailable ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !setting.isAvailable,
        child: Card(
          child: Padding(
            padding: const .all(Spacing.standard),
            child: SwitchListTile(
              title: Text(setting.title, style: const .new(fontSize: FontSize.title)),
              subtitle: Padding(
                padding: const .only(top: Spacing.standard),
                child: Text(setting.subtitle),
              ),
              value: setting.value,
              onChanged: (value) => setting.value = value,
            ),
          ),
        ),
      ),
    );
  }
}
