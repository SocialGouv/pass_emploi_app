import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

import '../../ui/app_colors.dart';
import '../../ui/shadows.dart';
import '../../ui/text_styles.dart';

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
    List<String> nonEmptyDataTags = dataTag.where((element) => element.trim().isNotEmpty).toList();
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: [
        Shadows.boxShadow,
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: InkWell(
            onTap: onTap ?? () {},
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Margins.spacing_base, 0, Margins.spacing_base, Margins.spacing_base),
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
                      SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrashButton() {
    return InkWell(
      splashColor: AppColors.primaryLighten,
      customBorder: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SvgPicture.asset(Drawables.icTrash),
      ),
      onTap: onDeleteTap ?? () {},
    );
  }

  Widget _buildDataTags(List<String> nonEmptyDataTags, String? lieu) {
    var list = nonEmptyDataTags.map((tag) => DataTag(label: tag)).toList();
    if (lieu != null) {
      list.add(DataTag(
        label: lieu,
        drawableRes: Drawables.icPlace,
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(spacing: 16, runSpacing: 16, children: list),
    );
  }
}
