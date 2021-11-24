import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

Container lightBlueTag({required String label, SvgPicture? icon}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.lightBlue,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Padding(padding: const EdgeInsets.only(right: 6), child: icon),
          Flexible(child: Text(label, style: TextStyles.textSmRegular())),
        ],
      ),
    ),
  );
}
