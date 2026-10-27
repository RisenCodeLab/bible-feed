import 'package:flutter/material.dart';

import '_constants.dart';
import 'bible_reader_link_icon.dart';
import 'bible_reader_settings_chips.dart';

class BibleReaderSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const .all(Spacing.standard),
        child: Row(
          crossAxisAlignment: .start,
          spacing: Spacing.standard,
          children: [
            BibleReaderLinkIcon(),
            Expanded(
              // https://docs.flutter.dev/ui/layout/constraints example 24-25
              child: Column(
                crossAxisAlignment: .start,
                spacing: Spacing.standard,
                children: [
                  const Text('Bible Reader', style: .new(fontSize: 20)),
                  const Text(
                    'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.',
                  ),
                  BibleReaderSettingsChips(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
