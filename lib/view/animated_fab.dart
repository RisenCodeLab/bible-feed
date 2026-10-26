import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class const AnimatedFab({
  required final Color backgroundColor,
  required final Color foregroundColor,
  required final IconData iconData,
  required final bool isVisible,
  required final String keyValue,
  required final Function() onPressed,
}) extends StatelessWidget {
  @override
  build(context) {
    const fabSize = 35.0;
    final animationDuration = 200.milliseconds;

    return AnimatedScale(
      duration: animationDuration,
      scale: isVisible ? 1 : 0,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        heroTag: keyValue, // must be unique across all FABs
        key: .new(keyValue),
        onPressed: onPressed,
        shape: const CircleBorder(),
        child: Icon(iconData, size: fabSize),
      ),
    );
  }
}
