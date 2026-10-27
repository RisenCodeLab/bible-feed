import 'package:flutter/material.dart';

class Constants {
  static const appbarIconSize = 32.0;
  static const blurSigma = 3.0;
  static const Radius defaultBorderRadius = .circular(12.0);
  static const deeplinkQueryKey = 'json';
  static const nonBreakingSpace = '\u00A0'; // ignore: avoid-non-ascii-symbols, nbsp is ok
}

class FontSize {
  static const standard = 14.0;
  static const subtitle = 18.0;
  static const title = 20.0;
}

class Spacing {
  static const EdgeInsets all = .all(8.0);
  static const EdgeInsets left = .only(left: 8.0);
  static const EdgeInsets right = .only(right: 8.0);
  static const double standard = 12.0;
}
