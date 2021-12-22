import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(immersion.nomEtablissement, style: TextStyles.textSmRegular(color: AppColors.bluePurple)),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              lightBlueTag(label: immersion.secteurActivite),
              lightBlueTag(label: immersion.ville, icon: SvgPicture.asset("assets/ic_place.svg")),
            ],
          )
        ],
      ),
    );
  }
}
