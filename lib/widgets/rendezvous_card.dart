import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RendezvousCard extends StatelessWidget {
  final RendezvousViewModel rendezvous;

  RendezvousCard(this.rendezvous);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(Margins.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rendezvous.date, style: TextStyles.textSmMedium(color: AppColors.nightBlue)),
            SizedBox(height: 4),
            Text(rendezvous.title, style: TextStyles.chapoSemi(color: AppColors.nightBlue)),
            SizedBox(height: 4),
            Text(rendezvous.subtitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          ],
        ),
      ),
    );
  }
}
