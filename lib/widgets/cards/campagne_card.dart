import 'package:flutter/material.dart';
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
        onTap: onTap,
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
    );
  }
}
