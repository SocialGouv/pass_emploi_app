import 'package:flutter/material.dart';

import 'app_colors.dart';

class PassEmploiTheme {
  static final data = ThemeData(
    toggleableActiveColor: AppColors.nightBlue,
    primarySwatch: Colors.indigo,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    checkboxTheme: _checkboxes(),
    sliderTheme: _sliders(),
  );

  static CheckboxThemeData _checkboxes() {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.contentColor, width: 2),
    );
  }

  static SliderThemeData _sliders() {
    return SliderThemeData(
      trackHeight: 6.0,
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.grey800,
      thumbColor: AppColors.primary,
      activeTickMarkColor: AppColors.primary,
      inactiveTickMarkColor: AppColors.grey800,
    );
  }
}
