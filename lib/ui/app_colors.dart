import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/brand.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static final Color primary = Brand.isBrsa() ? primaryDarken : Color(0xFF3B69D1);
  static const Color primaryDarken = Color(0xFF274996);
  static const Color primaryDarkenStrong = Color(0xFF172B5A);
  static const Color primaryLighten = Color(0xFFEEF1F8);
  static const Color primaryWithAlpha50 = Color(0x7A3B69D1);

  // Secondary colors
  static const Color secondary = Color(0xFF0D7F50);
  static const Color secondaryLighten = Color(0xFFE5F6EF);

  // Status colors
  static const Color warning = Color(0xFFD31140);
  static const Color warningLighten = Color(0xFFFDEAEF);
  static const Color success = Color(0xFF033C24);
  static const Color successLighten = Color(0xFFE5F6EF);
  static const Color alert = Color(0xFFFF975C);
  static const Color alertLighten = Color(0xFFFFC6A6);

  // Accent colors
  static const Color accent1 = Color(0xFF950EFF);
  static const Color accent1Lighten = Color(0xFFF4E5FF);
  static const Color accent2 = Color(0xFF4A526D);
  static const Color accent2Lighten = Color(0xFFF6F6F6);
  static const Color accent3 = Color(0xFF0C7A81);
  static const Color accent3Lighten = Color(0xFFDFFDFF);

  // Neutrals colors
  static const Color contentColor = Color(0xFF161616);
  static const Color disabled = Color(0xFF73758D);

  static const Color grey100 = Color(0xFFF1F1F1);
  static const Color grey500 = Color(0xFFB2B2B2);
  static const Color grey700 = Color(0xFF878787);
  static const Color grey800 = Color(0xFF646464);

  // Additional colors
  static const Color additional1Lighten = Color(0xFFFFD88D);
  static const Color additional1 = Color(0xFFFCBF49);
  static const Color additional2Lighten = Color(0xFFDDFFED);
  static const Color additional2 = Color(0xFF15616D);
  static const Color additional3Lighten = Color(0xFFD2CEF6);
  static const Color additional3 = Color(0xFF5149A8);
  static const Color additional4Lighten = Color(0xFFDBEDF9);
  static const Color additional4 = Color(0xFF2186C7);
  static const Color additional5Lighten = Color(0xFFCEF0F1);
  static const Color additional5 = Color(0xFF49BBBF);

  static const Color favoriteHeartColor = Color(0xFFA44C66);
  static const Color switchColor = Color(0xFF34C759);

  // Brands
  static const Color poleEmploi = Color(0xFF073A82);
  static const Color missionLocale = Color(0xFF942258);

  // Unreferenced colors
  static const Color loadingGreyPlaceholder = Color(0xFFE7E7E7);
  static const Color benevolat = Color(0xFF0A0E93);
}
