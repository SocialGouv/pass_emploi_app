import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

class DataCard<T> extends StatelessWidget {
  final String? category;
  final String titre;
  final String? sousTitre;
  final String? lieu;
  final List<String> dataTag;
  final VoidCallback onTap;
  final String? id;
  final OffrePage? from;
  final Widget? additionalChild;

  const DataCard({
    Key? key,
    required this.titre,
    required this.sousTitre,
    required this.lieu,
    required this.dataTag,
    required this.onTap,
    this.id,
    this.from,
    this.category,
    this.additionalChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> nonEmptyDataTags = dataTag.where((element) => element.isNotEmpty).toList();
    return CardContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category != null && category!.isNotEmpty) _buildCategory(category!),
                    _buildTitre(),
                    if (sousTitre != null && sousTitre!.isNotEmpty) _buildSousTitre(),
                    if (lieu != null && lieu!.isNotEmpty) _buildLieu(),
                  ],
                ),
              ),
              if (id != null && from != null)
                FavoriHeart<T>(
                  offreId: id!,
                  withBorder: false,
                  from: from!,
                )
            ],
          ),
          if (nonEmptyDataTags.isNotEmpty) _buildDataTags(nonEmptyDataTags),
          if (additionalChild != null) ...[
            SizedBox(height: Margins.spacing_base),
            additionalChild!,
          ],
        ],
      ),
    );
  }

  Widget _buildTitre() {
    return Text(titre, style: TextStyles.textBaseBold);
  }

  Widget _buildSousTitre() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        sousTitre!,
        style: TextStyles.textSBold,
      ),
    );
  }

  Widget _buildLieu() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(AppIcons.place_outlined, color: AppColors.grey800, size: Dimens.icon_size_base),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              lieu!,
              style: TextStyles.textSRegular(color: AppColors.grey800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTags(List<String> nonEmptyDataTags) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(spacing: 16, runSpacing: 16, children: nonEmptyDataTags.map(_buildTag).toList()),
    );
  }

  Widget _buildTag(String tag) {
    return DataTag(label: tag);
  }

  Widget _buildCategory(String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        category,
        style: TextStyles.textSRegular(color: AppColors.primary),
      ),
    );
  }
}
