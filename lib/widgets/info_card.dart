import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class InfoCard extends StatelessWidget {
  final String message;

  const InfoCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      backgroundColor: AppColors.primaryLighten,
      withShadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.info_rounded, color: AppColors.primary),
          SizedBox(width: Margins.spacing_s),
          Flexible(
            child: Text(message, style: TextStyles.textSMedium(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
