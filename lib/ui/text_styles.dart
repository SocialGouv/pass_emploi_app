import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'font_sizes.dart';

class TextStyles {
  TextStyles._();

  static final h3Semi = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  static chapoSemi({Color color = AppColors.nightBlue}) {
    return GoogleFonts.rubik(
      color: color,
      fontSize: FontSizes.semi,
      fontWeight: FontWeight.w500,
    );
  }

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

  static final textMdMedium = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  static final textMdRegular = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.3,
  );

  static textMenuRegular(Color color) {
    return GoogleFonts.rubik(
      color: color,
      fontSize: FontSizes.extraSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.3,
    );
  }

  static textSmMedium({Color color = AppColors.nightBlue}) {
    return GoogleFonts.rubik(
      color: color,
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w500,
    );
  }

  static textSmRegular({Color color = AppColors.nightBlue}) {
    return GoogleFonts.rubik(
      color: color,
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w400,
    );
  }

  static textXsRegular({Color color = AppColors.nightBlue}) {
    return GoogleFonts.rubik(
      color: color,
      fontSize: FontSizes.small,
      fontWeight: FontWeight.w400,
    );
  }
}
