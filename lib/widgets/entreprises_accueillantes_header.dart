import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class EntreprisesAccueillantesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLighten,
      padding: EdgeInsets.all(Margins.spacing_m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.info_rounded, color: AppColors.primary),
          SizedBox(width: Margins.spacing_s),
          Flexible(
            child: Text(
              Strings.entreprisesAccueillantesHeader,
              style: TextStyles.textBaseBoldWithColor(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
