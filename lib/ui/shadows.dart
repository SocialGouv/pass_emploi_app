import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class Shadows {
  static const boxShadow_m = BoxShadow(
    color: Color(0x33323232),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const boxShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 1,
    blurRadius: 8,
    offset: Offset(0, 6), // changes position of shadow
  );

  static const boxShadow_wide = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 0,
    blurRadius: 12,
    offset: Offset(0, 4),
  );
}
