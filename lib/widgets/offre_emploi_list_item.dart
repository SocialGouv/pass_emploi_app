import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

import 'favori_heart.dart';

class OffreEmploiListItem extends StatelessWidget {
  final OffreEmploiItemViewModel itemViewModel;
  final OffrePage from;

  const OffreEmploiListItem({required this.itemViewModel, required this.from}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        _content(),
        Positioned(
          top: 8,
          right: 8,
          child: FavoriHeart(offreId: itemViewModel.id, withBorder: false, from: from),
        )
      ]),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Strings.offreDetailNumber(itemViewModel.id),
            style: TextStyles.textXsRegular(),
          ),
          SizedBox(height: 8),
          Text(
            itemViewModel.title,
            style: TextStyles.textSmMedium(),
          ),
          if (itemViewModel.companyName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                itemViewModel.companyName!,
                style: TextStyles.textSmRegular(color: AppColors.bluePurple),
              ),
            ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Tag(label: itemViewModel.contractType),
              if (itemViewModel.duration != null) Tag(label: itemViewModel.duration!),
              if (itemViewModel.location != null)
                Tag(label: itemViewModel.location!, icon: SvgPicture.asset(Drawables.icPlace)),
            ],
          )
        ],
      ),
    );
  }
}
