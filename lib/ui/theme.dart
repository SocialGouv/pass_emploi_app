import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class PassEmploiTheme {
  static final data = ThemeData(
    // colorScheme is particularly useful to theme Android DatePicker dialogs
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    checkboxTheme: _checkboxes(),
    sliderTheme: _sliders(),
    progressIndicatorTheme: _progress(),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        return states.contains(MaterialState.selected) ? AppColors.primary : null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => Colors.white),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return AppColors.grey700;
        if (states.contains(MaterialState.selected)) return AppColors.success;
        return null;
      }),
    ),
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

  static ProgressIndicatorThemeData _progress() {
    return ProgressIndicatorThemeData(
      color: AppColors.primary,
    );
  }
}
