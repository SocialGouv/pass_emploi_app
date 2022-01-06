import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

import 'immersion_tags.dart';

class ImmersionListItem extends StatelessWidget {
  final Immersion immersion;

  const ImmersionListItem(this.immersion) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(immersion.metier, style: TextStyles.textSmMedium()),
          SizedBox(height: 8),
          Text(immersion.nomEtablissement, style: TextStyles.textSmRegular(color: AppColors.bluePurple)),
          SizedBox(height: 8),
          ImmersionTags(secteurActivite: immersion.secteurActivite, ville: immersion.ville),
        ],
      ),
    );
  }
}
