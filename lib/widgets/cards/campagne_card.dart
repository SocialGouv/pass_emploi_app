import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class CampagneCard extends StatelessWidget {
  final VoidCallback onTap;
  final String titre;
  final String description;

  const CampagneCard({super.key, required this.onTap, required this.titre, required this.description});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        backgroundColor: AppColors.accent1Lighten,
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(Drawables.evalImage),
            ),
            SizedBox(width: Margins.spacing_base),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre, style: TextStyles.textBaseBold),
                  SizedBox(height: Margins.spacing_s),
                  Row(
                    children: [
                      Flexible(child: Text(description, style: TextStyles.textSRegular())),
                      SizedBox(width: Margins.spacing_s),
                      Icon(AppIcons.chevron_right_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
