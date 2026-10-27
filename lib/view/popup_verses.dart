import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';

class const PopupVerses<T extends PopupManager>({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // golden screenshots render squares unless we specify the fontFamily
    final textStyle = TextStyle(color: sl<T>().foregroundColor, fontFamily: 'Roboto');
    final verses = sl<T>().verses ?? [];

    return Column(
      crossAxisAlignment: .center,
      children: verses.map((verse) {
        return Padding(
          padding: Spacing.all,
          child: RichText(
            textAlign: .center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: verse.text,
                  style: textStyle.copyWith(fontStyle: .italic),
                ),
                TextSpan(text: ' ', style: textStyle),
                TextSpan(
                  // ignore: avoid-non-ascii-symbols, long dash is ok
                  text: '— ${verse.reference}'.replaceAll(' ', Constants.nonBreakingSpace),
                  style: textStyle,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
