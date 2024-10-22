import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class A11yUtils {
  static void announce(String text) {
    // delay is needed to avoid the enouncement to be cut by voiceover
    Future.delayed(
      Duration(milliseconds: 100),
      () => SemanticsService.announce(text, TextDirection.ltr),
    );
  }

  static bool withTextScale(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0) > 1.0;
  }
}
