import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class Shadows {
  static const boxShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 1,
    blurRadius: 8,
    offset: Offset(0, 6), // changes position of shadow
  );
}
