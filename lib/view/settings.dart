import 'package:flutter/material.dart';

import '../model/catchup_setting.dart';
import '../model/chapter_split_setting.dart';
import '../model/haptic_setting.dart';
import '_constants.dart';
import 'app_version.dart';
import 'bible_reader_settings.dart';
import 'setting.dart';

class Settings extends StatelessWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.defaultSpacing).copyWith(top: 0),
            child: Column(
              spacing: Constants.defaultSpacing,
              children: [
                BibleReaderSettings(),
                Setting<ChapterSplitSetting>(),
                Setting<CatchupSetting>(),
                Setting<HapticSetting>(),
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
