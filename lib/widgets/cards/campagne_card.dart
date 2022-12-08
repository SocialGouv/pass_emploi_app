import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/generic_card.dart';

class CampagneCard extends StatelessWidget {
  final VoidCallback onTap;
  final String titre;
  final String description;

  const CampagneCard({Key? key, required this.onTap, required this.titre, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericCard(
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
    );
  }
}
