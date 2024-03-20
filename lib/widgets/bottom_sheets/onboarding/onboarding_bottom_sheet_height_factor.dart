import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';

double onboardingBottomSheetHeightFactor(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  if (height < MediaSizes.height_xs) return 0.9;
  if (height < MediaSizes.height_m) return 0.8;
  return 0.7;
}
