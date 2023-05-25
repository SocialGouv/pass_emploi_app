import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi_item_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';

class EvenementEmploiCard extends StatelessWidget {
  final EvenementEmploiItemViewModel _viewModel;

  const EvenementEmploiCard(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobTag(
            label: _viewModel.type,
            backgroundColor: AppColors.accent3Lighten,
          ),
          SizedBox(height: Margins.spacing_base),
          Text(_viewModel.titre, style: TextStyles.textMBold),
          SizedBox(height: Margins.spacing_s),
          _Date(date: _viewModel.dateLabel, heure: _viewModel.heureLabel),
          SizedBox(height: Margins.spacing_s),
          _Location(_viewModel.locationLabel),
          SizedBox(height: Margins.spacing_base),
          PressedTip(Strings.voirLeDetail),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final String date;
  final String heure;

  const _Date({required this.date, required this.heure});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.today_outlined, color: AppColors.grey800, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_xs),
        Text(date, style: TextStyles.textSMedium()),
        SizedBox(width: Margins.spacing_l),
        Icon(AppIcons.schedule, color: AppColors.grey800, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_xs),
        Text(heure, style: TextStyles.textSMedium()),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  final String _location;

  const _Location(this._location);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.location_on_rounded, color: AppColors.grey800, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_xs),
        Text(_location, style: TextStyles.textSMedium()),
      ],
    );
  }
}
