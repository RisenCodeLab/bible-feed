import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/haptic_manager.dart';
import '_build_context_extension.dart';
import 'app.dart';

class AppBase extends StatelessWidget {
  static const _lightPurple = Color(0xffbb86fc);

  @override
  build(context) {
    ThemeData theme(Brightness brightness) => .new(
      cardTheme: .new(surfaceTintColor: context.colorScheme.surfaceTint),
      colorScheme: .fromSeed(
        brightness: brightness,
        seedColor: _lightPurple,
        tertiary: brightness == .dark ? Colors.red : Colors.amber,
      ),
    );

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        navigatorObservers: [sl<HapticManager>()],
        title: 'Bible Feed',
        themeMode: .system,
        theme: theme(.light),
        darkTheme: theme(.dark),
        home: App(),
      ),
    );
  }
}
