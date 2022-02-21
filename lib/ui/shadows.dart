import 'package:flutter/material.dart';

import 'app_colors.dart';

class Shadows {
  static const boxShadow = BoxShadow(
    color: AppColors.shadowColor,
    spreadRadius: 1,
    blurRadius: 8,
    offset: Offset(0, 6), // changes position of shadow
  );
}
