import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';

class TextStyles {
  TextStyles._();

  static TextStyle textLBold({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.huge,
      fontWeight: FontWeight.w700,
      fontFamily: "Marianne",
    );
  }

  static TextStyle textSRegularWithColor(Color color) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w400,
      fontFamily: 'Marianne',
    );
  }

  static TextStyle textSMedium({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w500,
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

  static TextStyle textXsRegular({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.xs,
      fontWeight: FontWeight.w400,
      fontFamily: 'Marianne',
    );
  }

  static TextStyle textXsMedium({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.xs,
      fontWeight: FontWeight.normal,
      fontFamily: 'Marianne',
    );
  }

  static TextStyle textXsBold({Color color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontSize: FontSizes.xs,
      fontWeight: FontWeight.bold,
      fontFamily: 'Marianne',
    );
  }

  static final textPrimaryButton = TextStyle(
    color: Colors.white,
    fontSize: FontSizes.medium,
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
    fontWeight: FontWeight.w400,
    fontFamily: 'Marianne',
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );

  static final textSecondaryButton = TextStyle(
    color: AppColors.primary,
    fontSize: FontSizes.medium,
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

  static final textBaseUnderline = TextStyle(
    color: AppColors.primary,
    fontFamily: 'Marianne',
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  static TextStyle textBaseMediumBold({Color? color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontFamily: 'Marianne',
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.w600,
    );
  }

  static final textBaseMedium = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textMBoldWithColor({Color? color = AppColors.contentColor}) {
    return TextStyle(
      color: color,
      fontFamily: 'Marianne',
      fontSize: FontSizes.semi,
      fontWeight: FontWeight.w700,
    );
  }

  static final textMRegular = TextStyle(
    color: AppColors.contentColor,
    fontFamily: 'Marianne',
    fontSize: FontSizes.semi,
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

  static TextStyle textSRegular({
    Color color = AppColors.contentColor,
  }) {
    return TextStyle(
      color: color,
      decorationColor: color,
      fontFamily: 'Marianne',
      fontSize: FontSizes.normal,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle primaryAppBar = TextStyle(
    color: AppColors.primary,
    fontFamily: 'Marianne',
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.bold,
  );

  static final secondaryAppBar = TextStyles.textMBoldWithColor(color: AppColors.primary);

  static final accueilSection = TextStyles.textLBold(color: AppColors.primary);

  static TextStyle textBaseMediumWithColor(Color color) {
    return TextStyle(
      color: color,
      fontFamily: 'Marianne',
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle textBaseRegularWithColor(Color color) {
    return TextStyle(
      color: color,
      fontFamily: 'Marianne',
      fontSize: FontSizes.medium,
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
