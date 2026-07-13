import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feeds_manager.dart';
import 'feed.dart';

class Feeds extends StatelessWidget {
  // Columns and Rows work better than a GridView
  @override
  build(context) {
    var feedsManager = sl<FeedsManager>();
    return Column(
    children: [
      for (int index in [0, 2, 4, 6, 8])
        Expanded(
          child: Row(
            children: [
              Expanded(child: Feed(feedsManager.feedManagers[index])),
              Expanded(child: Feed(feedsManager.feedManagers[index + 1])),
            ],
          ),
        ),
    ],
  );
  }
}
