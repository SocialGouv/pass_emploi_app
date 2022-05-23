import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CampagneCard extends StatelessWidget {
  final VoidCallback onTap;
  final String titre;
  final String description;

  const CampagneCard({Key? key, required this.onTap, required this.titre, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        Shadows.boxShadow,
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titre, style: TextStyles.textBaseBold),
                  SizedBox(height: Margins.spacing_s),
                  Text(description, style: TextStyles.textSRegular()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
