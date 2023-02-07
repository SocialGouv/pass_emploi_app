import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

class SavedSearchCard extends StatelessWidget {
  final String title;
  final String? lieu;
  final List<String> dataTag;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;

  SavedSearchCard({
    required this.title,
    this.lieu,
    this.dataTag = const [],
    this.onTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> nonEmptyDataTags = dataTag.where((element) => element.trim().isNotEmpty).toList();
    return CardContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(title, style: TextStyles.textBaseBold),
                ),
              ),
              _buildTrashButton(),
            ],
          ),
          if (nonEmptyDataTags.isNotEmpty || lieu != null) _buildDataTags(nonEmptyDataTags, lieu),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(Strings.savedSearchSeeResults, style: TextStyles.textSRegular()),
              ),
              Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTrashButton() {
    return InkWell(
      splashColor: AppColors.primaryLighten,
      customBorder: CircleBorder(),
      onTap: onDeleteTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Icon(AppIcons.delete_rounded), // TODO: color (icTrash)
      ),
    );
  }

  Widget _buildDataTags(List<String> nonEmptyDataTags, String? lieu) {
    final list = nonEmptyDataTags.map((tag) => DataTag(label: tag)).toList();
    if (lieu != null) {
      list.add(DataTag(
        label: lieu,
        icon: AppIcons.location_on_rounded,
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(spacing: 16, runSpacing: 16, children: list),
    );
  }
}
