import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class DemarcheCard extends StatelessWidget {
  final DemarcheCardViewModel viewModel;
  final Function onTap;

  const DemarcheCard({required this.viewModel, required this.onTap}) : super();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [Shadows.boxShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => viewModel.isDetailEnabled ? onTap() : null,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.tag != null) _Tag(viewModel.tag!),
                  Text(viewModel.titre, style: TextStyles.textBaseBold),
                  if (viewModel.sousTitre != null) _SousTitre(viewModel.sousTitre!),
                  if (viewModel.createdByAdvisor) _CreatorText(),
                  _Date(viewModel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final UserActionTagViewModel viewModel;

  const _Tag(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: StatutTag(
        backgroundColor: viewModel.backgroundColor,
        textColor: viewModel.textColor,
        title: viewModel.title,
      ),
    );
  }
}

class _SousTitre extends StatelessWidget {
  final String sousTitre;

  const _SousTitre(this.sousTitre);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Text(
        sousTitre,
        style: TextStyles.textSRegular(color: AppColors.contentColor),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _CreatorText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Text(Strings.createByAdvisor, style: TextStyles.textSRegularWithColor(AppColors.primary)),
    );
  }
}

class _Date extends StatelessWidget {
  final DemarcheCardViewModel viewModel;

  const _Date(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
          child: Container(
            height: 1,
            color: AppColors.primaryLighten,
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(Drawables.icClock, color: viewModel.getDateColor()),
            SizedBox(width: Margins.spacing_s),
            _DateTitle(title: viewModel.formattedDate, isLate: viewModel.isLate, color: viewModel.getDateColor()),
          ],
        ),
      ],
    );
  }
}

class _DateTitle extends StatelessWidget {
  final String title;
  final bool isLate;
  final Color color;

  const _DateTitle({required this.title, required this.isLate, required this.color});

  @override
  Widget build(BuildContext context) {
    if (isLate) {
      return Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: Strings.demarcheLate, style: TextStyles.textBaseBoldWithColor(color)),
              TextSpan(text: title, style: TextStyles.textSRegularWithColor(color)),
            ],
          ),
        ),
      );
    }
    return Text(title, style: TextStyles.textSRegularWithColor(color));
  }
}
