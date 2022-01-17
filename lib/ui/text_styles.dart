import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'font_sizes.dart';

class TextStyles {
  TextStyles._();

  static final textLgMedium = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.large,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static final textMdMedium = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  static TextStyle textLBold({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.huge,
      fontWeight: FontWeight.w700,
      fontFamily: "Marianne",
    );
  }

  static final textMdRegular = GoogleFonts.rubik(
    color: AppColors.nightBlue,
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.3,
  );

  static TextStyle textSRegularWithColor(Color color) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w400,
      fontFamily: 'Marianne',
    );
  }

  static TextStyle textSBoldWithColor(Color color) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w700,
      fontFamily: 'Marianne',
    );
  }

  static TextStyle textMenuRegular(Color color) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.extraSmall,
      fontWeight: FontWeight.w700,
      fontFamily: 'Marianne',
    );
  }

  static TextStyle textXsRegular({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.xs,
      fontWeight: FontWeight.w400,
      fontFamily: 'Marianne',
    );
  }

  static final textPrimaryButton = TextStyle(
    color: Colors.white,
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.w700,
    fontFamily: 'Marianne',
  );

  static final externalLink = TextStyle(
    color: AppColors.primaryDarken,
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w700,
    fontFamily: 'Marianne',
    decoration: TextDecoration.underline,
  );

  static final internalLink = TextStyle(
    color: AppColors.primary,
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w700,
    fontFamily: 'Marianne',
    decoration: TextDecoration.underline,
  );

  static final textSecondaryButton = TextStyle(
    color: AppColors.primary,
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.w700,
    fontFamily: 'Marianne',
  );

  static final textBaseBold = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w700,
  );

  static final textBaseRegular = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w400,
  );

  static final textSBold = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.w700,
  );

  static final textMBold = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.semi,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textSRegular({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontFamily: 'Marianne',
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w400,
    );
  }

  static final textAppBar = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.semi,
    fontWeight: FontWeight.w700,
  );

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

  static TextStyle textBaseBoldWithColor(Color color) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.w700,
      fontFamily: 'Marianne',
    );
  }
}
