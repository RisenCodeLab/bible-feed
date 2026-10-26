import 'package:flutter/material.dart';

import '_build_context_extension.dart';
import '_constants.dart';

// highlight selected item
class const ListWheelHighlight({required final double height}) extends StatelessWidget {
  @override
  build(context) {
    return Align(
      alignment: .center,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.colorScheme.tertiary,
          borderRadius: const .all(Constants.defaultBorderRadius),
        ),
      ),
    );
  }
}
