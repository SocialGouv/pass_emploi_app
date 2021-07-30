import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'font_sizes.dart';

class TextStyles {
  static final h3Semi = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  static final textLgMedium = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.large,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static final textLgSemi = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.large,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static final textSmRegular = GoogleFonts.rubik(
    color: Colors.black,
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.w400,
  );
}
