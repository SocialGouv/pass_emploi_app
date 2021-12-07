import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

class OffreEmploiListItem extends StatelessWidget {
  final OffreEmploiItemViewModel itemViewModel;

  const OffreEmploiListItem({required this.itemViewModel}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                lightBlueTag(label: itemViewModel.contractType),
                if (itemViewModel.duration != null) lightBlueTag(label: itemViewModel.duration!),
                if (itemViewModel.location != null)
                  lightBlueTag(label: itemViewModel.location!, icon: SvgPicture.asset("assets/ic_place.svg")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
